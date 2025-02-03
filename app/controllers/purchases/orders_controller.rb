class Purchases::OrdersController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include SupplierFilter
	include Reopen
	include BasicCrud
	include Delivereable

	# def deliver
	# 	if order.update(order_params)
	# 		Purchases::OrderMailer.send_to_client(order, params[:email]).deliver
	# 		redirect_to edit_purchases_order_path(order.id), notice: "La orde de venta fue enviada con éxito"
	# 	else
	# 		render :edit
	# 	end
	# end

	private

		def order_params
			params.require(:purchases_order).permit(:entity_id, :document_observation, :number, :file_id, :oc_type, :user_id, :subtotal, :discount, :total, :total_usd, :usd_price, :expected_delivery_date, :shipping_included, :oc_number_from_os, :shipping_price, :state, :observation, :note, :currency,
				details_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :branch, :product_code, :quantity, :product_measurement, :price, :discount, :total, :iva_aliquot, :iva_amount, :_destroy,
					childs_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :branch, :product_code, :quantity, :product_measurement, :price, :discount, :total, :iva_aliquot, :iva_amount, :_destroy],
				],
				custom_details_attributes: [:id, :tipo, :iva_aliquot, :quantity, :product_name, :price, :total, :_destroy],
				attachments_attributes: [:id, :file, :original_filename, :_destroy],
				order_payment_days_attributes: [:id, :payment_type_id, :observation, :_destroy],
				custom_attributes: current_company.purchase_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
			  orders_budgets_attributes: [:id, :budget_id, :_destroy]
			)
		end
end
