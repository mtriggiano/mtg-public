class Purchases::BillsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud
  include SupplierFilter

  def index_by_supplier
    bills = ExternalBill.where(company_id: current_company.id)
      .approveds
      .unpaid
      .not_credito_notes
      .where(entity_id: params[:secondary_data])
      .search(params[:q])
      .order(:number)
      .map { |sr| { id: sr.id, text: "#{sr.name(:short)} - TOTAL: $ #{sr.total} - SALDO: $ #{sr.real_total_left}", total_left: sr.real_total_left, tipo_comprobante: sr.cbte_tipo, credit_note: false } }
    credit_notes = ExternalBill.where(company_id: current_company.id)
      .approveds
      .unpaid
      .only_credit_notes
      .where(entity_id: params[:secondary_data], parent_bill: nil) # sólo aquellas sin asociar
      .search(params[:q])
      .order(:number)
      .map { |sr| { id: sr.id, text: "#{sr.name(:short)} - TOTAL: $ #{sr.total} - SALDO: $ #{sr.real_total_left}", total_left: sr.real_total_left, tipo_comprobante: sr.cbte_tipo, credit_note: true } }
    result = bills + credit_notes
    render json: result
  end

  def new
    super
    bill.entity_id = params[:supplier_id] if params[:supplier_id]
  end

  def edit
    super
    bill.entity_id = params[:supplier_id] if params[:supplier_id]
  end

  def associate_document
    bill.associate(params[:bill])
    render :new
  end

  private

  def bill_params
    params.require(:purchases_bill).permit(:purchase_arrival_id, :entity_id, :cbte_tipo, :sale_point, :number, :cbte_fch, :registration_date, :due_date, :file_id, :user_id, :total_trib, :total, :usd_price, :total_usd, :iva_amount, :company_id, :state, :attachment, :observation, :concept, :fch_ser_desde, :fech_ser_hasta, :fch_vto_pago, :gross_amount, :currency,
      details_attributes: [:id, :number, :product_id, :product_name, :product_code, :quantity, :price, :iva_aliquot, :discount, :product_measurement, :iva_amount, :subtype, :total, :_destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
      bills_orders_attributes: [:id, :order_id, :_destroy],
      bills_arrivals_attributes: [:id, :arrival_id, :_destroy],
      tributes_attributes: [:id, :afip_id, :base_imp, :alic, :amount, :description, :_destroy],
      custom_attributes: current_company.purchase_bill_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
    )
  end
end
