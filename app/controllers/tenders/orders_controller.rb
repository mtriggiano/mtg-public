class Tenders::OrdersController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
	include Delivereable

	# def deliver
	# 	if order.update(order_params)
	# 		Sales::OrderMailer.send_to_client(order, params[:email]).deliver
	# 		redirect_to edit_tenders_order_path(order.id), notice: "La orde de venta fue enviada con éxito"
	# 	else
	# 		render :edit
	# 	end
	# end

	private

		def order_params
			params.require(:tenders_order).permit(:entity_id, :number, :file_id, :order_type, :user_id, :subtotal, :discount, :total, :expected_delivery_date, :state, :observation, :total_usd, :usd_price, :currency,
				details_attributes: [:id, :detail_type, :base_offer, :product_id, :product_name, :user_id, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :iva_aliquot, :_destroy,
					childs_attributes: [:id, :detail_type, :base_offer, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :iva_aliquot, :_destroy],
				],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
      			custom_details_attributes: [:id, :tipo, :product_code, :discount, :product_measurement, :iva_aliquot, :quantity, :product_name, :price, :total, :_destroy],
				orders_budgets_attributes: [:id, :budget_id, :_destroy],
      			custom_attributes: current_company.tender_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
			)
		end
end
