class Purchases::BudgetsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def budget_params
  			params.require(:purchases_budget).permit(:number, :entity_id, :entity_contact_id, :delivery_date, :delivery_address, :init_date, :final_date, :discount, :total, :total_usd, :usd_price, :state, :observation, :file_id, :currency,
  				details_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :quantity, :branch, :product_code, :product_measurement, :price, :iva_aliquot, :iva_amount, :discount, :total, :_destroy,
						childs_attributes: [:id, :number, :detail_type, :base_offer, :product_id, :product_name, :quantity, :branch, :product_code, :product_measurement, :price, :iva_aliquot, :iva_amount, :discount, :total, :_destroy],
					],
					attachments_attributes: [:id, :file, :original_filename, :_destroy],
					custom_attributes: current_company.purchase_budget_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
  				budgets_purchase_requests_attributes: [:id, :request_id, :_destroy]
  			)
  		end
end
