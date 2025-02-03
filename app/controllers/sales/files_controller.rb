class Sales::FilesController < ApplicationController
  layout false, only: :for_calendar
	expose :files, ->{ current_company.sale_files.includes([:client])}
	expose :file, scope: ->{ files }
  include Indexable
  include Alertable
  include Attachable
  skip_load_and_authorize_resource only: [:index_by_company, :index_by_client, :get_file_data, :for_calendar]

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
  			if file.update(file_params) && (can?(:update, file) || can?(:manage, Calendar))
  				format.html { redirect_to sales_file_path(file.id, view: params[:view]), notice: "Expediente de venta actualizado con éxito" }
  			else
  				format.html { render :edit }
  			end
  		end
  	end

  	def destroy
  		respond_to do |format|
  			if file.destroy
  				format.html { redirect_to sales_files_path, notice: "Expediente de venta eliminado con éxito" }
  			else
  				format.html { redirect_to sales_files_path, alert: file.errors.full_messages.first }
  			end
  		end
  	end

    def for_calendar
      @files = collection.where(finish_date: params[:date])
    end

    def index_by_client
      render json: files.where(client_id: params[:extra_data]).map{|sf| {id: sf.id, text: sf.full_name} }
    end

    def index_by_company
      render json: current_company.sale_files.search(params[:q]).map{|file| {id: file.id, text: file.full_name}}
    end

    def get_file_data
      render json: {
        client: {
          id:file.entity_id,
          name: file.client.name
        },
        iva_aliquot: file.iva_aliquot,
        iibb_perception: file.client.iibb_perception,
        iibb_aliquot: file.client.iibb_perception,
        available_cbte_tipo: BillManager::AfipBill.new(nil, company: current_company, entity: file.client).cbte_types}.to_json
    end

  	private

  	def file_params
    		params.require(:sales_file).permit(:entity_id, :title, :number, :province, :pacient, :doctor,
          :pacient_number, :sale_type, :init_date, :finish_date, :open, :substate, :iva_aliquot,
          :need_surgical_sheet, :need_implant, :need_sticker, :need_note,
          :place, :user_id, :initial_department, :external_number, :external_shipment_number, :external_purchase_order_number,
          :implant_original_filename, :implant_certificate, :surgical_sheet, :surgical_sheet_original_filename, :note, :note_original_filename,
          :sticker, :sticker_original_filename,
          :implant_state, :surgical_sheet_state,
          :delivery_date, :delivery_hour, :technical,
          responsables_attributes: [:id, :document_type, :user_id, :destroy]
        )
  	end
end
