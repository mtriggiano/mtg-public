class Surgeries::ClientBillsController < ApplicationController
  include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
  before_action :set_barcode, only: :show
  skip_load_and_authorize_resource only: [:set_manual, :associate_document]

  def index_by_client
    #authorize! :read, SaleBill
    render json: current_company.surgery_bills.joins(:client).unpaid.where("sale_bills.comp_number ILIKE LOWER(?) AND clients.id = ?", "#{params[:term]}%", params[:extra_data]).map{|sc| {id: sc.id, text: sc.name, total_left: sc.total_left}}
  end

  def new
    super
    client_bill.set_concept
  end

  def edit
    super
    client_bill.set_concept
  end

  def set_manual
    client_bill.manual = params[:manual]
  end

  def associate_document
    client_bill.associate(params[:bill])
    render :new
  end

  private

  def client_bill_params
    params.require(:surgeries_client_bill).permit(:parent_bill, :due_days, :note, :cbte_fch, :payment_type_id, :number, :manual, :fch_ser_desde, :fech_ser_hasta, :file_id, :delivery_note_id, :cbte_tipo, :entity_id, :date, :iva_cond, :concept, :sale_file_id, :sale_point, :user_id, :iva_amount, :state, :observation, :fch_serv_desde, :fch_serv_hasta, :fch_vto_pago, :gross_amount, :total_usd, :usd_price, :currency,
      file_attributes: [:id, :external_purchase_order_number, :external_number, :pacient, :pacient_number],
      details_attributes: [:id, :number, :subtype, :seller_id, :state, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :bonus_amount, :discount, :iva_aliquot, :iva_amount, :store_id, :total, :_destroy
      ],
      tributes_attributes: [:id, :afip_id, :base_imp, :alic, :amount, :description, :_destroy],
      client_bills_sale_orders_attributes: [:id, :order_id, :_destroy],
      client_bills_shipments_attributes: [:id, :shipment_id, :_destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
      custom_attributes: current_company.surgery_client_bill_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
    )
  end

  def set_barcode
    @barcode_path = "#{Rails.root}/tmp/invoice#{client_bill.id}_barcode.png"
  end
end
