class Surgeries::FilesController < ApplicationController
	#skip_load_and_authorize_resource
	layout false, only: :for_calendar
	expose :files, ->{ current_company.surgery_files.includes([:client])}
	expose :file, scope: ->{ files }
	include Indexable
	include Alertable
	include Attachable

	skip_load_and_authorize_resource only: [:index_by_company, :index_by_client, :get_file_data, :for_calendar, :update, :vencidos]

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
				format.html { redirect_to file, notice: "Expediente de cirugía creado con éxito" }
			else
        		pp file.errors
				format.html { render :new }
			end
		end
	end

	def update
		if can?(:update, file) || can?(:manage, Calendar)
	     	file.current_user = current_user
			respond_to do |format|
				if file.update(file_params)
					format.html { redirect_to polymorphic_path(file, view: params[:view]), notice: "Expediente de cirugía actualizado con éxito" }
				else
					format.html { render :edit }
				end
			end
		end
	end

	def destroy
		respond_to do |format|
			if file.destroy
				format.html { redirect_to url_for(action: :index, only_path: true), notice: "Expediente de cirugía eliminado con éxito" }
			else
				format.html { redirect_to url_for(action: :index, only_path: true), alert: file.errors.full_messages.first }
			end
		end
	end

	def for_calendar
		@files = collection.where(surgery_end_date: params[:date])
	end

  	def index_by_client
    	render json: files.where(client_id: params[:extra_data]).map{|sf| {id: sf.id, text: sf.full_name} }
  	end

   	def index_by_company
    	render json: current_company.surgery_files.search(params[:q]).map{|file| {id: file.id, text: file.full_name}}
  	end

	def vencidos
		@fecha = 5.business_days.ago
		@expedients = Surgeries::File.where("files.custom_attributes->'surgical_sheet' IS NULL OR files.custom_attributes->'surgical_sheet' = ''")
		@expedients = @expedients.where("files.custom_attributes->'implant_certificate' IS NULL OR files.custom_attributes->'implant_certificate' = ''")
		@expedients = @expedients.preload(:sale_orders).joins(:sale_orders).where('orders.expected_delivery_date <= ?', @fecha)
		@expedients = @expedients.order('orders.expected_delivery_date DESC')
		@expedients = @expedients.where("files.created_at > ?", DateTime.new(2024, 1, 1))
		filtered

		if request.format.json?
		  render json: Surgeries::FileVencidosDatatable.new(params, view_context: view_context, collection: @expedients), status: 200
		end
	end

	def new_cambiar_seller
	end

	def create_cambiar_seller
		seller = User.find file_params[:seller_id_temp] 
		ActiveRecord::Base.transaction do
			file.sale_orders.each do |sale_order|
				sale_order.details.update_all(user_id: seller.id)
			end
	
			file.client_bills.each do |client_bill|
				client_bill.details.update_all(seller_id: seller.id)
			end

			file.budgets.update_all(seller_id: seller.id)
			
			file.purchase_orders.each do |purchase_order|
				purchase_order.details.update_all(user_id: seller.id)
			end
		end
		redirect_to file, notice: "Vendedor actualizado correctamente"
	rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Error de validación: #{e.message}"
    redirect_to :new_cambiar_seller
	end

	# toggle de vencido a no vencido y viceversa
	def excluir_de_vencidos
		if @file.cx_notificacions.present? 
			@file.cx_notificacions.delete_all
			redirect_back(fallback_location: root_path, notice: "Expediente fue marcado como Vencido correctamente.")
		else
		  cx_notificacion = @file.cx_notificacions.build(tipo: "equipo_ventas")
			if cx_notificacion.save
				redirect_back(fallback_location: root_path, notice: "Expediente fue marcado como NO Vencido correctamente.")
			else
				redirect_back(fallback_location: root_path, alert: "Ha ocurrido un error: #{cx_notificacion.errors.full_messages}")
			end
		end
	end

  	def get_file_data
    	render json: {
	    	client: {
	    		id:file.entity_id,
	    		name: file.client.name
	    	},
	    	province: file.province,
	    	pacient: file.pacient_with_number,
	    	doctor: file.doctor,
	    	place: file.place,
	    	init_date: I18n.l(file.init_date),
	    	finish_date: file.finish_date.nil? ? I18n.l(file.init_date + 1.months, format: :short) : I18n.l(file.finish_date, format: :short),
	    	surgery_end_date: file.surgery_end_date.blank? ? nil : I18n.l(file.surgery_end_date),
	    	shipping: file.shipping,
				iva_aliquot: file.iva_aliquot,
				detail: file.sale_type,
	    	available_cbte_tipo: BillManager::AfipBill.new(nil, company: current_company, entity: file.client).cbte_types}.to_json
  	end

  	private
	    def get_holidays
		    from = Date.current - 30.day
		    to = Date.current
		    Holidays.between(from, to, :ar, :observed).map{|holiday| BusinessTime::Config.holidays << holiday[:date]}
	    end

		  def filtered
				if params[:filtros].present? && filtro_params[:estado_notificacion] == 'Marcados como No Vencidos'
					@expedients = @expedients.joins("LEFT JOIN cx_notifications ON files.id = cx_notifications.fileable_id").where("cx_notifications.fileable_id IS NOT NULL")
				else
					@expedients = @expedients.joins("LEFT JOIN cx_notifications ON files.id = cx_notifications.fileable_id").where("cx_notifications.fileable_id IS NULL")
				end
		  end

			def filtro_params
				params.require(:filtros).permit(
					:estado_notificacion,
				)
			end

	  	def file_params
		  		params.require(:surgeries_file).permit(:entity_id, :number, :external_number, :doctor,
		  			:detail, :province, :pacient, :pacient_number, :place, :title, :init_date,
					:note_original_filename, :note, :sticker_original_filename, :sticker,
					:need_surgical_sheet, :need_surgical_sheet_2, :need_implant, :need_sticker, :need_note,
					:seller_id_temp,
		  			:finish_date, :open, :substate, :iva_aliquot, :user_id, :initial_department,
		  			:surgery_end_date, :external_purchase_order_number, :external_shipment_number, :implant_original_filename,
		  			:implant_certificate, :surgical_sheet, :surgical_sheet_original_filename, :surgical_sheet_2, :surgical_sheet_original_filename_2,
					:implant_state, :surgical_sheet_state, :surgical_sheet_state_2,
					:delivery_date, :delivery_hour, :technical,
		        	responsables_attributes: [:id, :document_type, :user_id, :destroy]
		      	)
	  	end
end
