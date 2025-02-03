class Surgeries::PurchaseOrdersController < ApplicationController
  	include Attachable
  	include Fileable
  	include CanAddDetail
  	include Indexable
  	include ClientFilter
  	include Reopen
  	include BasicCrud
    include Delivereable

  	# def deliver
  	# 	if purchase_order.update(purchase_order_params)
  	# 		Purchases::OrderMailer.send_to_client(purchase_order, params[:email]).deliver
  	# 		redirect_to edit_surgeries_purchase_order_path(purchase_order.id), notice: "La orde de venta fue enviada con éxito"
  	# 	else
  	# 		render :edit
  	# 	end
	  # end

	private

		def purchase_order_params
			params.require(:surgeries_purchase_order).permit(:entity_id, :document_observation,:number, :note, :file_id, :oc_type, :user_id, :subtotal, :discount, :total, :total_usd, :usd_price, :expected_delivery_date, :shipping_included, :shipping_price, :state, :observation, :currency, :subtotal, :oc_number_from_os,
				details_attributes: [:id, :number,:detail_type, :base_offer, :product_id, :product_name, :product_supplier_code, :quantity, :product_measurement, :price, :discount, :total, :iva_aliquot, :_destroy,
					childs_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :product_supplier_code, :quantity, :product_measurement, :price, :discount, :total, :iva_aliquot, :_destroy],
				],
				attachments_attributes: [:id, :file, :original_filename, :_destroy],
				order_payment_days_attributes: [:id, :payment_type_id, :observation, :_destroy],
				custom_details_attributes: [:id, :tipo, :quantity, :product_name, :price, :total, :iva_aliquot, :_destroy],
				custom_attributes: current_company.surgery_purchase_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
				purchase_orders_purchase_requests_attributes: [:id, :request_id, :_destroy],
        		purchase_orders_consumptions_attributes: [:id, :shipment_id, :_destroy]
			)
		end
end
