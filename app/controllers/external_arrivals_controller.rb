class ExternalArrivalsController < ApplicationController
	include Indexable
	include BasicCrud
	include Fileable
	include CanAddDetail
  	include Reopen
  	include Traceable
	before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

	def index
		if params[:file_id]
			render json: ExternalArrivalDatatable.new(params, view_context: view_context, collection: current_company.expedients.find(params[:file_id]).arrivals), status: 200
		else
			if request.format.json?
				if params[:for_select]
					collection = current_company.external_arrivals.search(params[:q])
					if collection.respond_to?(:approveds)
						render json: collection.approveds.map(&:attributes)
					else
						render json: collection.map(&:attributes)
					end
				else
					authorize! :read, obj
					render json: "#{controller_path.classify}Datatable".constantize.new(params, view_context: view_context, collection: current_company.external_arrivals), status: 200
				end
			else
				authorize! :read, obj
			end
		end
	end

	def new_stock
	  @external_shipment = ExternalShipment.traslado_stock.find(params[:shipment_id])
	  @external_arrival = @external_shipment.external_arrival
	  if @external_arrival.nil?
		@external_arrival = current_company.external_arrivals.traslado_stock.build
		@external_arrival.external_shipment = @external_shipment
		@external_arrival.traslado_stock_interno = true 
		@external_arrival.date = Date.current
		@external_arrival.current_user = current_user
		@external_arrival.supplier = current_company.suppliers.where(name: "MAGNUS S.A.", document_number: "30711222630").first
		@external_shipment.details.each do |external_shipment_detail|
			detail = @external_arrival.details.build(
			number: nil,
			product_id: external_shipment_detail.product_id,
			product_name: external_shipment_detail.product_name,
			product_code: external_shipment_detail.product_code,
			branch: external_shipment_detail.branch,
			requested_quantity: external_shipment_detail.quantity,
			quantity: external_shipment_detail.quantity,
			)
			external_shipment_detail.batch_details.each do |batch_detail|
			detail.batch_details.build(
				batch_id: batch_detail.batch_id,
				quantity: batch_detail.quantity,
				store_id: batch_detail.store_id,
				#detail_type: batch_detail.detail_type,	
			)
			end
		end
		empty_detail = @external_arrival.details.select{ |detail| detail.product_name.nil? }
		@external_arrival.details.delete(empty_detail)
		@external_arrival.save(validate: false)
	  else
		@external_arrival.current_user = current_user
	  end

	  redirect_to [:edit, @external_arrival], notice: "Entrada fue creada correctamente"
	end

	# Creacion de una nueva entradas de stock para movimiento iterno.
	def create_stock
	  @external_shipment = ExternalShipment.traslado_stock.find(params[:shipment_id])
	  @external_arrival = @external_shipment.external_arrival
	  @external_arrival ||= current_company.external_arrivals.traslado_stock.build
	  @external_arrival.update_attributes(external_arrival_params)
	  @external_arrival.current_user = current_user
	  if @external_arrival.save
		redirect_to [:edit, @external_arrival], notice: t('.success')
	  else
		render :new_stock
	  end
	end

	private
		#TODO Separar parametros de administrador de los parametros de un usuario comun
		def external_arrival_params
			params.require(:external_arrival).permit(:store_id, :number, :entity_id, :date, :punctuation, :state, :observation, :delivered_shipments,
        	details_attributes:  [:id, :number, :transaction_id, :detail_type, :product_id, :product_name, :branch, :product_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
	          	gtin_attributes: [:id, :code],
	          	batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]],
	          	childs_attributes: [:id, :number, :detail_type, :product_id, :transaction_id, :serial, :product_name, :branch, :product_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
	            	gtin_attributes: [:id, :code],
	            	batch_details_attributes: [:id, :quantity, :_destroy, batch_attributes: [:id, :code, :moved_quantity, :serial, :transaction_id, :due_date, :_destroy]],
	          	],
        	],
        	attachments_attributes: [:id, :file, :original_filename, :_destroy],
        	external_arrivals_expedient_requests_attributes: [:id, :request_id, :_destroy],
        	external_arrivals_expedient_orders_attributes: [:id, :order_id, :_destroy]
      )
		end
end