module Anmat
    class Shipment
        include Virtus.model()
        attribute :shipment, ExpedientShipment

        def send_medicamentos
            shipment.details.includes(:batches, :inventary, childs: [:batches, :inventary]).each do |detail|
                send_transaction(detail) unless detail.inventary.gtin.blank?
                detail.childs.each {|child| send_transaction(child) unless child.inventary.gtin.blank? }
            end
        end

        def send_transaction detail
            detail.batches.each do |batch|
                response = Anmat::Traceability.new.send_medicamentos(
                    f_evento: I18n.l(Date.today),
                    h_evento: I18n.l(Time.now, format: :time),
                    n_remito: shipment.number,
                    vencimiento: I18n.l(batch.due_date || Date.today),
                    #gtin: detail.inventary.gtin.rjust(14,'0'),
                    #lote: batch.code.rjust(20,'0'),
                    id_evento: shipment.id_evento,
                    #gln_destino: shipment.client.gln,
                    #numero_serial: batch.serial
                )
                unless response[:resultado]
                    shipment.errors.add(:base,"A.N.M.A.T.: #{response[:errores]}")
                end
            end
        end
    end
end
