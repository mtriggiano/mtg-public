class Surgeries::SupplierBillsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud

  def new
    supplier_bill.entity_id = params[:surgeries_supplier_bill][:entity_id] if params[:surgeries_supplier_bill]
    super
  end

  private
  def supplier_bill_params
    params.require(:surgeries_supplier_bill).permit(:entity_id, :cbte_tipo, :sale_point, :number, :cbte_fch, :due_date, :file_id, :user_id, :gross_amount, :total, :iva_amount, :company_id, :state, :attachment, :observation, :gross_amount, :total_usd, :usd_price, :currency,
      details_attributes: [:id, :number, :product_id, :subtype, :product_name, :product_supplier_code, :quantity, :product_measurement, :price, :iva_aliquot, :discount, :iva_amount, :total, :_destroy,
        childs_attributes: [:id, :number, :product_id, :subtype, :product_name, :product_supplier_code, :quantity, :product_measurement, :price, :iva_aliquot, :discount, :iva_amount, :total, :_destroy],
      ],
      supplier_bills_purchase_orders_attributes: [:id, :order_id, :_destroy],
      supplier_bills_arrivals_attributes: [:id, :arrival_id, :_destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
      custom_attributes: current_company.surgery_supplier_bill_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
    )
  end
end
