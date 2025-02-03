class ExternalShipmentsController < ApplicationController
	include Indexable
	include BasicCrud
	include Fileable
	include CanAddDetail
  	include Reopen
  	include Traceable
	before_action :set_s3_direct_post, only: [:new, :edit, :create, :update]

	def index
		if params[:file_id]
			render json: ExternalShipmentDatatable.new(params, view_context: view_context, collection: current_company.expedients.find(params[:file_id]).arrivals), status: 200
		else
			if request.format.json?
				if params[:for_select]
					collection = current_company.external_shipments.search(params[:q])
					if collection.respond_to?(:approveds)
						render json: collection.approveds.map(&:attributes)
					else
						render json: collection.map(&:attributes)
					end
				else
					authorize! :read, obj
					render json: "#{controller_path.classify}Datatable".constantize.new(params, view_context: view_context, collection: current_company.external_shipments), status: 200
				end
			else
				authorize! :read, obj
			end
		end
	end

	def update
    respond_to do |format|
      if external_shipment.update(external_shipment_params)
        if params[:request_stock] && !params[:verify_stock]
          current_request, purchase_request = external_shipment.create_purchase_request
          if current_request.nil? && purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, external_shipment], notice: "Ya existe una solicitud de stock."}
          elsif current_request.nil? && purchase_request.nil? && !params[:request_stock]
            format.html{ redirect_to [:edit, external_shipment], notice: "Se actualizo existosamente."}
          elsif current_request.nil? && !purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, external_shipment], notice: "Se generó un expediente de compras."}
          elsif !current_request.nil? && purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, current_request], notice: "Se genero la solicitud de stock. Por favor complete los datos."}
          elsif !current_request.nil? && !purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, current_request], notice: "Se genero la solicitud de stock y un expediente de compra. Por favor complete los datos."}
          end
        elsif params[:verify_stock] && !params[:request_stock]
          external_shipment.check_stock
          format.html { redirect_to [:edit, external_shipment], notice: "Stock actualizado, por favor revise."}
        else
          format.html { redirect_to [:edit, external_shipment], notice: "Documento actualizado."}
        end
      else
				pp external_shipment.errors
        format.html{ render :edit }
      end
    end
  end

  # Nueva funcionalidad para manejar el movimiento de stock entre dos depositos de Magnus

  # Listado de las salidas de stock para movimiento iterno.
  def stock
	@external_shipments = current_company.external_shipments.traslado_stock.includes(
		:store, 
		:details, 
		:client,
		external_arrival: [
			:details, 
			:store
		]).order(created_at: :desc)
	@estados_entradas = ExternalArrival.traslado_stock.pluck(:state).uniq
	@estados_salidas = ExternalShipment.traslado_stock.pluck(:state).uniq
	@stores = Store.where(id: ExternalShipment.select(:store_id).distinct.pluck(:store_id))
	  .or(
		Store.where(id: ExternalArrival.select(:store_id).distinct.pluck(:store_id))
	  )
	@products = Product.where(
		id: ExternalArrivalDetail.traslado_stock.pluck(:product_id).uniq
	).or(
		Product.where(id: ExternalShipmentDetail.traslado_stock.pluck(:product_id).uniq)
	)

	filtered 
	if request.format.json?
	  render json: ExternalShipmentStockDatatable.new(params, view_context: view_context, collection: @external_shipments), status: 200
	end
  end

  # Creacion de una nueva salidas de stock para movimiento iterno.
  def new_stock
	@external_shipment = current_company.external_shipments.traslado_stock.build
	@external_shipment.shipment_type = "Traslado"
	@external_shipment.date = Date.current
	@external_shipment.client = current_company.clients.where(document_number: "30711222630", denomination: "MAGNUS SA").first
  end

  # Creacion de una nueva salidas de stock para movimiento iterno.
  def create_stock
	@external_shipment = current_company.external_shipments.traslado_stock.build(external_shipment_params)
	@external_shipment.current_user = current_user
	@external_shipment.shipment_type = "Traslado"
	@external_shipment.client = current_company.clients.where(document_number: "30711222630", denomination: "MAGNUS SA").first
	if @external_shipment.save
	  redirect_to [:edit, @external_shipment], notice: t('.success')
	else
	  render :new_stock
	end
  end

  private
    def filtered
	  return unless params[:filtros].present?

	  if filtro_params[:store_salida_id].present?
        @external_shipments = @external_shipments.by_store(filtro_params[:store_salida_id])
      end
	  if filtro_params[:store_entrada_id].present?
        @external_shipments = @external_shipments.by_store_entrada(filtro_params[:store_entrada_id])
      end

	  @external_shipments = @external_shipments.fecha_desde(filtro_params[:salida_fecha_desde]) if  filtro_params[:salida_fecha_desde].present?  
      @external_shipments = @external_shipments.fecha_hasta(filtro_params[:salida_fecha_hasta]) if  filtro_params[:salida_fecha_hasta].present?  
	  @external_shipments = @external_shipments.entrada_fecha_desde(filtro_params[:entrada_fecha_desde]) if  filtro_params[:entrada_fecha_desde].present?  
      @external_shipments = @external_shipments.entrada_fecha_hasta(filtro_params[:entrada_fecha_hasta]) if  filtro_params[:entrada_fecha_hasta].present?  
	  @external_shipments = @external_shipments.by_estado(filtro_params[:estado_salida]) if  filtro_params[:estado_salida].present?  
	  @external_shipments = @external_shipments.by_estado_entrada(filtro_params[:estado_entrada]) if  filtro_params[:estado_entrada].present?  
	end

		#TODO Separar parametros de administrador de los parametros de un usuario comun
		def external_shipment_params
			params.require(:external_shipment).permit(:store_id, :number, :entity_id, :date, :punctuation, :state, :observation, :shipment_type,
        	details_attributes:  [:id, :transaction_id, :detail_type, :product_id, :product_name, :branch, :product_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
	          	gtin_attributes: [:id, :code],
	          	batch_details_attributes: [:id, :quantity, :batch_id, :_destroy],
	          	childs_attributes: [:id, :detail_type, :product_id, :transaction_id, :serial, :product_name, :branch, :product_code, :requested_quantity, :quantity, :description, :product_measurement, :_destroy,
	            	gtin_attributes: [:id, :code],
	            	batch_details_attributes: [:id, :quantity, :batch_id, :_destroy],
	          	],
        	],
        	attachments_attributes: [:id, :file, :original_filename, :_destroy],
      )
		end
		def filtro_params
		  params.require(:filtros).permit(
		    :tipo,
		    :store_salida_id,
			:store_entrada_id,
		    :entrada_fecha_desde,
			:entrada_fecha_hasta,
			:salida_fecha_desde,
			:salida_fecha_hasta,
		    :estado_entrada,
		    :estado_salida,
		    :product_id
		  )
		end
end
