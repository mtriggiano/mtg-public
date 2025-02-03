class Surgeries::ArrivalsController < ApplicationController
  include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud


  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def arrival_params
  			params.require(:surgeries_arrival).permit(:store_id, :file_id, :number, :entity_id, :date, :punctuation, :state, :observation,
          details_attributes:  [:id, :transaction_id, :detail_type, :product_id, :product_name, :product_supplier_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
            gtin_attributes: [:id, :code],
            batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]],
            childs_attributes: [:id, :detail_type, :product_id, :transaction_id, :serial, :product_name, :product_supplier_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
              gtin_attributes: [:id, :code],
              batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]],
            ],
          ],
          attachments_attributes: [:id, :file, :original_filename, :_destroy],
          custom_attributes: current_company.surgery_arrival_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
          arrivals_purchase_requests_attributes: [:id, :request_id, :_destroy]
        )
  		end
end
