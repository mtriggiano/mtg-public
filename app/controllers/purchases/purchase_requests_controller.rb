class Purchases::PurchaseRequestsController < ApplicationController
  include Attachable
  include CanAddDetail
  include Fileable

  include Indexable

  include ClientFilter
  include Reopen
  include BasicCrud

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def purchase_request_params
  			params.require(:purchases_purchase_request).permit(:user_id, :init_date, :final_date, :entity_id, :due_date, :urgency, :state, :number, :observation, :request_type, :file_id,
  				details_attributes: [:id, :number, :state, :base_offer, :detail_type, :branch,:product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy,
						childs_attributes: [:id, :number, :state, :base_offer, :branch, :detail_type, :product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy],
						],
						attachments_attributes: [:id, :file, :original_filename, :_destroy],
						custom_attributes: current_company.purchase_purchase_request_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
					)
  		end
end
