class Sales::SaleRequestsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def sale_request_params
  			params.require(:sales_sale_request).permit(:entity_id, :init_date, :final_date, :urgency, :state, :number, :observation, :request_type, :file_id,
				details_attributes: [:id, :number, :detail_type, :branch,:state, :product_code, :base_offer, :product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy,
        			childs_attributes: [:id, :number, :detail_type, :branch, :product_code, :base_offer, :state, :product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy],
      			],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
      			custom_attributes: current_company.sale_sale_request_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym} + [:pacient, :place, :doctor, :date, :insurance, :shipping]
      		)
  		end
end
