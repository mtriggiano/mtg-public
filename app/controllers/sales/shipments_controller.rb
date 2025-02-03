class Sales::ShipmentsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include ShowPdf
	include Reopen
	include BasicCrud
	include Delivereable
	include Traceable

	def new_from_bill
		authorize! :create, SaleShipment
		sale_shipment.new_from_bill(params[:sale_bill_id])
		render :new
	end

	def conform
		authorize! :update, shipment
		shipment.update(conformed_params)
		redirect_to [:edit, shipment]
	end

	private
		#TODO Separar parametros de administrador de los parametros de un usuario comun
		def shipment_params
			params.require(:sales_shipment).permit(:store_id, :file_id, :number, :sale_order_id, :entity_id, :date, :punctuation, :state, :observation, :shipment_type,
				:from, :to, :id_evento, :conformed, :conformed_file,
  			location_attributes: [:id, :address, :map, :contact, :phone, :observation],
  			details_attributes: [:id,:uniq, :branch, :product_id, :product_name, :product_code, :requested_quantity, :quantity, :observation, :product_measurement, :quantity_per_batch, :due_date, :_destroy,
  				batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
        			gtin_attributes: [:id, :code],
            	childs_attributes: [:id, :product_id, :branch, :product_name, :product_code, :requested_quantity, :quantity, :observation, :product_measurement, :due_date, :_destroy,
            	batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
        			gtin_attributes: [:id, :code]],
          	],
          	custom_details_attributes: [:id, :tipo, :product_code, :code, :serial, :due_date, :product_name, :product_measurement, :quantity, :_destroy],
        		attachments_attributes: [:id, :file, :original_filename, :_destroy],
				custom_attributes: current_company.sale_shipment_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
  			shipments_orders_attributes: [:id, :order_id, :_destroy]
  		)
		end

		def conformed_params
			params.require(:sales_shipment).permit(:conformed, :conformed_file)
		end
end
