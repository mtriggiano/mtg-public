class Tenders::BillsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud
  before_action :set_barcode, only: :show
  skip_load_and_authorize_resource only: :set_manual

  def set_manual
    bill.manual = params[:manual]
  end

  private

  def bill_params
    params.require(:tenders_bill).permit(:reception_date, :note, :due_days, :sale_point, :payment_type_id, :manual, :estimated_days_to_pay, :receptor_name, :parent_bill, :delivery_note_id, :cbte_tipo, :entity_id, :date, :iva_cond, :concept, :file_id, :tender_order_id, :tender_point, :user_id, :iva_amount, :state, :observation, :fch_serv_desde, :fch_serv_hasta, :fch_vto_pago, :cbte_fch, :fch_ser_desde, :fech_ser_hasta, :gross_amount, :usd_price, :total_usd, :total_trib, :currency,
      details_attributes: [:id, :seller_id, :subtype, :state, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :bonus_amount, :discount, :iva_aliquot, :iva_amount, :store_id, :total, :_destroy,
        childs_attributes: [:id, :subtype, :state, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :bonus_amount, :discount, :iva_aliquot, :iva_amount, :store_id, :total, :_destroy]
      ],
      tributes_attributes: [:id, :afip_id, :base_imp, :alic, :amount,  :description,:_destroy],
      bills_orders_attributes: [:id, :order_id, :_destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
      custom_attributes: current_company.tender_bill_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
    )
  end

  def set_barcode
    @barcode_path = "#{Rails.root}/tmp/invoice#{bill.id}_barcode.png"
  end
end
