class Sales::OrdersController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include ShowPdf
	include Reopen
	include BasicCrud
	include Delivereable


	private

		def order_params
			params.require(:sales_order).permit(:entity_id, :number, :file_id, :order_type, :user_id, :subtotal, :discount, :total, :total_usd, :usd_price, :expected_delivery_date, :state, :observation, :currency, :subtotal,
				details_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :user_id, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :iva_aliquot, :iva_amount, :_destroy,
					childs_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :product_code, :product_measurement, :quantity, :price, :discount, :total, :description, :iva_aliquot, :iva_amount, :_destroy],
				],
				custom_details_attributes: [:id, :tipo, :product_code, :discount, :product_measurement, :iva_aliquot, :quantity, :product_name, :price, :total, :_destroy],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
				orders_budgets_attributes: [:id, :budget_id, :_destroy],
      			custom_attributes: current_company.sale_order_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
			)
		end
end
