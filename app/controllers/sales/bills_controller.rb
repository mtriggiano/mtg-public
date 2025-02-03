class Sales::BillsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include ShowPdf
  include BasicCrud
  include Tributable

  before_action :set_barcode, only: :show
  skip_load_and_authorize_resource only: [:index_by_client, :set_manual, :associate_document]

  def index_by_client
    result = ExpedientBill.where(company_id: current_company.id)
      .approveds
      .unpaid
      .where(entity_id: params[:secondary_data])
      .search(params[:q])
      .order(:number)
      .first(5)
      .map{|sr| {id: sr.id, text: sr.full_name, total_left: sr.total_left}}
    render json: result
  end

  def new
    assign_details if bill.respond_to?(:assign_details)
    add_tributes
  end

  def associate_document
    bill.associate(params[:bill])
    render :new
  end

  def set_manual
    bill.manual = params[:manual]
  end

  def export
    zip_data, filename = BillManager::Exporter.new(bill).export
    send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
  end

  private

  def bill_params
    params.require(:sales_bill).permit(:reception_date, :note, :due_days, :payment_type_id, :number, :manual, :estimated_days_to_pay, :receptor_name, :parent_bill, :delivery_note_id, :cbte_tipo, :entity_id, :date, :iva_cond, :concept, :file_id, :sale_order_id, :sale_point, :user_id, :iva_amount, :state, :observation, :fch_serv_desde, :fch_serv_hasta, :fch_vto_pago, :cbte_fch, :fch_ser_desde, :fech_ser_hasta, :gross_amount, :total_usd, :usd_price, :currency,
      file_attributes: [:id, :external_purchase_order_number, :external_number, :pacient, :pacient_number],
      details_attributes: [:id, :number, :seller_id, :subtype, :state, :branch, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :bonus_amount, :discount, :iva_aliquot, :iva_amount, :store_id, :total, :_destroy,
        childs_attributes: [:id, :subtype, :state, :product_id, :branch,  :product_name, :product_code, :product_measurement, :quantity, :price, :bonus_amount, :discount, :iva_aliquot, :iva_amount, :store_id, :total, :_destroy]
      ],
      tributes_attributes: [:id, :afip_id, :base_imp, :alic, :amount, :description, :_destroy],
      optionals_attributes: [:id, :afip_id, :valor, :_destroy],
      bills_orders_attributes: [:id, :order_id, :_destroy],
      bills_shipments_attributes: [:id, :shipment_id, :_destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
      custom_attributes: current_company.sale_bill_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
    )
  end

  def set_barcode
    @barcode_path = "#{Rails.root}/tmp/invoice#{bill.id}_barcode.png"
  end
end
