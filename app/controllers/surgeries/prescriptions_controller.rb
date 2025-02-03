class Surgeries::PrescriptionsController < ApplicationController
  include Attachable
  include CanAddDetail
  include Fileable
  include Indexable
  
  include ClientFilter
  include Reopen
  include BasicCrud

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def prescription_params
  			params.require(:surgeries_prescription).permit(:entity_id, :init_date, :final_date, :urgency, :state, :number, :observation, :request_type, :file_id, :transport, :pacient, :place, :doctor, :insurance, :shipping, :date,
				details_attributes: [:id, :number, :detail_type, :base_offer, :state, :product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy,
        			childs_attributes: [:id, :number, :detail_type, :base_offer, :state, :product_id, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :_destroy],
      			],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
      			custom_attributes: current_company.surgery_prescription_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym} + [:pacient, :place, :doctor, :date, :insurance, :shipping]
      		)
  		end
end
