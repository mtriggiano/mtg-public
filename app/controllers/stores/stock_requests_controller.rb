class Stores::StockRequestsController < ApplicationController

  	expose :external_store, scope: ->{ current_company.external_stores}, id: ->{ params[:external_id] }
	expose :stock_requests, ->{ external_store.requests }
	expose :stock_request, scope: ->{ external_store.requests }

	skip_load_and_authorize_resource

	def index
		respond_to do |format|
			format.html
			format.js
			if params[:view_format] == "details"
				format.json { render json: StockRequestDetailDatatable.new(params, view_context: view_context, external_store: external_store), status: 200 }
			else
				format.json { render json: StockRequestDatatable.new(params, view_context: view_context, external_store: external_store), status: 200 }
			end
		end
	end

  	def show
  	end

  	def new
  	end

  	def edit
  	end

  	def create
  		stock_request.company_id = current_company.id
		if stock_request.save
			redirect_to edit_stores_stock_request_path(stock_request.id, external_id: external_store.id), notice: "Solicitud creada con éxito"
		else
			render :new
		end
	end

	def update
		respond_to do |format|
			if stock_request.update(stock_request_params)
				if not params[:view_format].blank?
					format.html {redirect_to stores_stock_requests_path(view_format: params[:view_format], external_id: params[:external_id]), notice: "Actualizacion exitosa"}
					format.js {render :edit}
				else
					format.html {redirect_to edit_stores_stock_request_path(stock_request.id, external_id: external_store.id), notice: "Actualizacion exitosa"}
				end
			else
				format.html {render :edit}
			end
		end
	end

	def destroy
		if stock_request.destroy
			redirect_to stores_stock_requests_path(external_id: params[:external_id]), notice: "Se eliminó la solicitud con éxito"
		else
			render :show
		end
	end

	def change_state
		respond_to do |format|
			if Request.new(stock_request, params[:state]).change_state
				format.html { redirect_to edit_stores_stock_request_path(stock_request, external_id: external_store.id), notice: "Solicitud actualizada con éxito"}
			else
				format.html { render :edit}
			end
		end
	end

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def stock_request_params
  			params.require(:stock_request).permit(:user_id, :store_line_id, :date, :due_date, :urgency, :number, :observation, :reason, :purchase_file_id,
  				details_attributes: [:id, :product_id, :quantity, :state, :product_name, :measurement_unit, :observation, :_destroy])
  		end
end
