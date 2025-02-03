class Surgeries::SaleOrdersController < ApplicationController
 	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
  include Delivereable

  skip_load_and_authorize_resource only: :get_details

	def get_details
		sale_orders = current_company.surgery_sale_orders.where(id: params[:sale_order_ids])
		@details = sale_orders.map(&:details).flatten
	end

	# def deliver
	# 	if sale_order.update(sale_order_params)
	# 		Sales::OrderMailer.send_to_client(sale_order, params[:email]).deliver
	# 		redirect_to edit_surgeries_sale_order_path(sale_order.id), notice: "La orde de venta fue enviada con éxito"
	# 	else
	# 		render :edit
	# 	end
	# end

	private

		def sale_order_params
			params.require(:surgeries_sale_order).permit(:entity_id, :note, :number, :file_id, :order_type, :user_id, :subtotal, :discount, :total, :total_usd, :usd_price, :expected_delivery_date, :state, :observation, :currency, :subtotal,
				details_attributes: [:id, :number, :detail_type, :source, :branch, :base_offer, :product_id, :product_name, :user_id, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :iva_aliquot,  :_destroy,
					childs_attributes: [:id, :number, :detail_type, :source, :branch, :base_offer, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :_destroy],
				],
        file_attributes: [:id, :external_purchase_order_number],
      	attachments_attributes: [:id, :file, :original_filename, :_destroy],
				sale_orders_budgets_attributes: [:id, :budget_id, :_destroy],
				custom_details_attributes: [:id, :tipo, :quantity, :product_name, :price, :total, :product_code, :discount, :product_measurement, :iva_aliquot, :_destroy],
      			custom_attributes: current_company.surgery_sale_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
			)
		end

    def set_permission
  		authorize! :read, Surgeries::SaleOrder
  	end
end
