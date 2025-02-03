class Surgeries::FileMovementsController < ApplicationController
  	include Alertable
  	expose :file, scope: -> { current_company.surgery_files}, id: ->{ params[:surgery_file_id] || params[:file_movement].try(:[], :file_id)}
  	expose :file_movements,->{file.file_movements}
  	expose :file_movement, scope: ->{file.file_movements}, model: "Surgeries::FileMovement"
    skip_load_and_authorize_resource
  	include Indexable

  	def new
  	end

  	def edit; end

  	def show; end

  	def create
  		file_movement.file_type = "Surgeries"
		if file_movement.save
			redirect_to surgeries_file_path(file_movement.file_id, view: 'movements'), notice: "Movimiento creado con éxito"
		else
			pp file_movement.errors
			render :new
		end
	end

	def update
		if file_movement.update(file_movement_params)
			redirect_to surgeries_file_path(file_movement.file_id, view: 'movements'), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if file_movement.destroy
			redirect_to surgeries_file_path(file.id, view: 'movements'), notice: "Se eliminó el movimiento con éxito"
		else
			render :show
		end
	end

	private

		def file_movement_params
			params.require(:surgeries_file_movement).permit(:sended_by, :department_id, :file_id)
		end
end
