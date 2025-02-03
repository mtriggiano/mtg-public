class Tenders::FilesController < ApplicationController
	expose :files, ->{ current_company.tender_files.includes([:client])}
	expose :file, scope: ->{ files }
  	include Indexable
  	include Alertable
  	include Attachable

	skip_load_and_authorize_resource only: [:index_by_company, :index_by_client, :get_file_data]

	def show
    if params[:view] == "alerts" && request.format == :json
      render json: AlertDatatable.new(params, view_context: view_context, company: current_company, object: file.alerts(current_user)), status: 200
    end
  end

	def new
	end

	def edit
	end

	def create
    file.current_user = current_user
		respond_to do |format|
			if file.save
				format.html { redirect_to file, notice: "Expediente de venta creado con éxito" }
			else
        pp file.errors
				format.html { render :new }
			end
		end
	end

	def update
    file.current_user = current_user
		respond_to do |format|
			if file.update(file_params)
				format.html { redirect_to tenders_file_path(file.id, view: params[:view]), notice: "Expediente de venta actualizado con éxito" }
			else
				format.html { render :edit }
			end
		end
	end

	def destroy
		respond_to do |format|
			if file.destroy
				format.html { redirect_to tenders_files_path, notice: "Expediente de venta eliminado con éxito" }
			else
				format.html { redirect_to tenders_files_path, alert: file.errors.full_messages.first }
			end
		end
	end

  def index_by_client
    render json: files.where(client_id: params[:extra_data]).map{|sf| {id: sf.id, text: sf.full_name} }
  end

  def index_by_company
    render json: current_company.tender_files.search(params[:q]).map{|file| {id: file.id, text: file.full_name}}
  end

  def get_file_data
    render json: {
      client: {
        id:file.entity_id,
        name: file.client.name
      },
      iva_aliquot: file.iva_aliquot,
      available_cbte_tipo: BillManager::AfipBill.new(nil,company: current_company, entity: file.client).cbte_types}.to_json
  end

	private

	def file_params
		params.require(:tenders_file).permit(:delivery_date, :delivery_hour, :external_number, :technical, :doctor, :substate, :objeto, :pliego, :pliego_original_filename, :forma_pago, :precio_pliego, :resolution, :objeto, :destinos, :procediment, :reception, :open_date, :open_hs, :sistema_apertura, :entity_id, :title, :number, :sale_type, :init_date, :finish_date, :open, :state, :iva_aliquot, :user_id, :initial_department, :place,
      :province, :pacient, :pacient_number, responsables_attributes: [:id, :document_type, :user_id, :destroy],
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
			budget_attachments_attributes: [:id, :file, :objeto, :detail, :entity_id, :entity_name, :original_filename, :_destroy],

    )
	end
end
