module Anmat
  class Arrival
    include Virtus.model()
    attribute :arrival, ExternalArrival
    attribute :anmat_document, Hash
    attribute :n_remito, String
    attribute :documents, ExpedientRequest
    attribute :anmat_detail, Hash
    attribute :arrival_detail, ExternalArrivalDetail
    attribute :batch, Batch

    def assign
      set_header
      documents.includes(details: [:product, childs: :product]).each do |document|
        document.details.each do |document_detail|
          if arrival.details.select{|d| d.product_id == document_detail.product_id}.any?
            @arrival_detail = arrival.details.select{|d| d.product_id == document_detail.product_id}.first
          else
            @arrival_detail = arrival.details.build
          end
          @arrival_detail.assign_from_another(document_detail)
          unless anmat_document.compact.blank?
            work_detail
            arrival_detail.childs.each do |child|
              if arrival_detail.childs.select{|d| d.product_id == child.product_id}.any?
                @arrival_detail = arrival_detail.childs.select{|d| d.product_id == child.product_id}.first
              else
                @arrival_detail = child
              end
              work_detail
            end
          end
        end
      end
      unless anmat_document.compact.blank?
        @anmat_document[:details].each do |anmat_detail|
          @anmat_detail = anmat_detail
          @arrival_detail = arrival.detail.build
          merge_details(anmat_detail)
        end
      end
    end

    def work_detail
      @anmat_detail = anmat_document[:details].select{|d| d[:product_name] == arrival_detail.product_name}
      merge_details(anmat_detail[0])
      remove_used_detail(anmat_detail)
    end

    def autocomplete
      arrival.details.select{|d| d if d.product_id.blank?}.each(&:mark_for_destruction)
      anmat = Anmat::Traceability.new()
      build_transactions_hash(anmat.transacciones_no_confirmadas({n_remito: n_remito}))
    end

    def anmat_document
      if @anmat_document.blank?
        @anmat_document = (n_remito.blank? || documents.blank?) ? [nil] : autocomplete
      else
        @anmat_document
      end
    end

    def remove_used_detail detail
      index = anmat_document[:details].index(detail)
      @anmat_document[:details].delete_at(index) unless index.nil?
    end

    def set_header
      unless anmat_document.compact.blank?
        arrival.entity_id  ||= anmat_document.try(:[],:entity_id) unless anmat_document.try(:[], :entity_id).nil?
        arrival.date       ||= anmat_document.try(:[],:date)
        arrival.number     ||= anmat_document.try(:[],:number)
      end
    end

    def build_transactions_hash response
      transacciones = response.try(:[],:transacciones)
      return [nil] if transacciones.nil?

      header = {
        number: transacciones.dig(0, :_n_remito),
        entity_id: arrival.company.suppliers.find_by(gln: transacciones.dig(0,:_gln_origen)).try(:id),
        date: transacciones.dig(0, :_f_evento)
      }

      details = transacciones.group_by{|t| {
        product_name: t[:_nombre],
        transaction_id: t[:_id_transaccion_global],
        batch: {
          code: t[:_lote],
          due_date: t[:_vencimiento]
        }
      }}.each do |key, values|
        key[:batch][:gtins] = values.map{|v| {code: v[:_gtin], serial: v[:_numero_serial], transaction_id: v[:_id_transaccion]}}
      end
      header[:details] = details.keys
      return header
    end

    def merge_details(anmat_detail)
      @anmat_detail = anmat_detail
      if !anmat_detail.blank?
        product =  Inventary.get_or_create(anmat_detail[:product_name], arrival.company)
        fill_detail_from_product(product)
        @arrival_detail.transaction_id = anmat_detail[:transaction_id]
        build_batch_from_anmat
        batch.gtins.each_with_index do |gtin, i|
          gtin.code = anmat_detail.dig(:batch, :gtins, i, :code)
          gtin.transaction_id = anmat_detail.dig(:batch, :gtins, i, :transaction_id)
          gtin.serial = anmat_detail.dig(:batch, :gtins, i, :serial)
        end
      end
    end

    def fill_detail_from_product product
      @arrival_detail.product_id           ||= product.try(:id)
      @arrival_detail.product_name         ||= product.try(:name)
      @arrival_detail.product_measurement  ||= product.try(:medida)
      @arrival_detail.requested_quantity   ||= 0.0
      @arrival_detail.requested_quantity   += anmat_detail[:requested_quantity]

      @arrival_detail.quantity = anmat_detail.dig(:batch, :gtins).size if arrival_detail.quantity == 0.0
    end

    def build_batch_from_anmat
      @batch = arrival_detail.build_batch(code: anmat_detail.dig(:batch, :code), due_date: anmat_detail.dig(:batch, :due_date))
    end
  end
end
