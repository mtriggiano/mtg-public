class AgreementSurgeries::SaleOrdersController < ApplicationController
  expose :sale_orders, ->{ current_company.agreement_surgery_sale_orders }
  expose :sale_order, scope: -> {sale_orders}, model: "AgreementSurgeries::SaleOrder"
  
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud
  include Delivereable

  before_action :set_s3_direct_post

  skip_load_and_authorize_resource only: :get_details

	def get_details
		sale_orders = current_company.agreement_surgery_sale_orders.where(id: params[:sale_order_ids])
		@details = sale_orders.map(&:details).flatten
	end
  
  def index_by_company
  	render json: current_company.agreement_sale_orders.search(params[:q]).map{|file| {id: file.id, text: file.full_name}}
  end

  def sale_order_params
      params.require(:agreement_surgeries_sale_order).permit(
        :entity_id, 
        :note,
        :number, 
        :file_id, 
        :order_type, 
        :user_id, 
        :subtotal, 
        :discount, 
        :total, 
        :total_usd, 
        :usd_price, 
        :expected_delivery_date, 
        :state, 
        :observation, 
        :currency,
        :subtotal,
        details_attributes: [
          :id, 
          :number, 
          :detail_type,
          :base_offer, 
          :product_id, 
          :product_name,
          :user_id, 
          :product_code,
          :product_measurement, 
          :quantity, 
          :price, 
          :discount, 
          :total, 
          :description, 
          :iva_aliquot,
          :surgery_material_description,
          :surgery_material_id ,
           :_destroy,
          childs_attributes: [
            :id, :number, :detail_type, :source, :branch, :base_offer, :product_id, :product_name,
            :product_code, :product_measurement, :nomenclador, :quantity, :price, :discount, :total, :description, :_destroy
          ],
        ],
        file_attributes: [:id, :external_purchase_order_number],
        attachments_attributes: [:id, :file, :original_filename, :_destroy],
        sale_orders_budgets_attributes: [:id, :budget_id, :_destroy],
        custom_details_attributes: [:id, :tipo, :quantity, :product_name, :nomenclador, :price, :total, :product_code, :discount, :product_measurement, :iva_aliquot, :_destroy],
            custom_attributes: current_company.surgery_sale_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
      )
    end

end
