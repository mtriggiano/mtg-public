class Surgeries::SurgeryFileMovementsController < ApplicationController
  	skip_load_and_authorize_resource
  	include Alertable
  	expose :surgery_file, scope: -> { current_company.surgery_files}, id: ->{ params[:surgery_file_id] || params[:surgery_file_movement][:file_id]} 
  	expose :surgery_file_movements,->{surgery_file.movements}
  	expose :surgery_file_movement, scope: ->{surgery_file.movements}

  	def index
		respond_to do |format|
			format.html
			format.js
			format.json { render json: SaleFileMovementDatatable.new(params, view_context: view_context, sale_file: surgery_file), status: 200 }
		end
	end

  	def new; end

  	def edit; end

  	def show; end

  	def create
		if surgery_file_movement.save
			redirect_to surgery_file_path(surgery_file.id, view: 'movements'), notice: "Movimiento creado con éxito"
		else
			render :new
		end
	end

	def update
		if surgery_file_movement.update(surgery_file_movement_params)
			redirect_to surgery_file_path(surgery_file.id, view: 'movements'), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if surgery_file_movement.destroy
			redirect_to surgery_file_path(surgery_file.id, view: 'movements'), notice: "Se eliminó el movimiento con éxito"
		else
			render :show
		end
	end

	private

		def surgery_file_movement_params
			params.require(:surgery_file_movement).permit(:sended_by, :department_id)
		end
end
