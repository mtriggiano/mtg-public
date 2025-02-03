class Purchases::ArrivalsController < ApplicationController
  layout false, only: :get_gtins
  include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud

	def get_gtins; end

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def arrival_params
  			params.require(:purchases_arrival).permit(:store_id, :file_id, :number, :order_id, :entity_id, :date, :punctuation, :state, :observation,
          details_attributes:  [:id, :number, :transaction_id, :detail_type, :product_id, :product_name, :product_supplier_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
            gtin_attributes: [:id, :code],
            batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]],
            childs_attributes: [:id, :number, :detail_type, :transaction_id, :product_id, :product_name, :product_supplier_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
              gtin_attributes: [:id, :code],
              batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]]
            ],
          ],
          attachments_attributes: [:id, :file, :original_filename, :_destroy],
  				custom_attributes: current_company.purchase_arrival_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
	  			arrivals_orders_attributes: [:id, :order_id, :_destroy]
	  		)
  		end
end
