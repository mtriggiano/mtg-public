class Purchases::FilesController < ApplicationController
  	expose :files,->{current_company.purchase_files.includes([:user])}
  	expose :file, scope: 	->{ files }
  	include Alertable
  	include Indexable

    skip_load_and_authorize_resource only: [:index_by_company, :get_file_data]

  	def new; end

  	def edit; end

  	def show
  		if params[:view] == "alerts" && request.format == :json
	     render json: AlertDatatable.new(params, view_context: view_context, company: current_company, collection: file.alerts(current_user)), status: 200
		  end
  	end

  	def create
    	file.current_user = current_user
		if file.save
			redirect_to file, notice: "Expediente creado con éxito"
		else
      		pp file.errors
			render :new
		end
	end

	def update
		if file.update(file_params)
			redirect_to purchases_file_path(file.id, view: params[:view]), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if file.destroy
			redirect_to purchases_files_path(), notice: "Se eliminó el expediente con éxito"
		else
			redirect_to purchases_files_path, alert: file.errors.full_messages.first 
		end
	end

	def index_by_company
		render json: current_company.purchase_files.map{|file| {id: file.id, text: file.full_name}}
	end

	def get_file_data
      render json: {iva_aliquot: file.iva_aliquot}.to_json
    end

	private

		def file_params
			params.require(:purchases_file).permit(:title, :number, :init_date, :finish_date, :open, :state, :user_id, :initial_department,
		        responsables_attributes: [:id, :document_type, :user_id, :destroy],
		    )
		end
end
