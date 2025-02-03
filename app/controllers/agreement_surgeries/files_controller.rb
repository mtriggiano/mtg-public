class AgreementSurgeries::FilesController < ApplicationController
  expose :files, ->{ current_company.agreement_surgery_files }
  expose :file, scope: ->{ files }
  
  include Indexable
  include Alertable
  include Attachable
  include BasicCrud

  def update
    authorize! :update, file
    file.current_user = current_user
    
    respond_to do |format|
      if file.update(file_params)
        format.html { redirect_to file, notice: "Solicitud actualizada con éxito" }
      else
        format.html { render :edit }
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
      pacient: file.pacient_number,
      doctor: file.doctor,
      place: file.place,
      init_date: I18n.l(file.init_date),
      finish_date: file.finish_date.nil? ? I18n.l(file.init_date + 1.months, format: :short) : I18n.l(file.finish_date, format: :short),
      surgery_end_date: file.surgery_end_date.blank? ? nil : I18n.l(file.surgery_end_date),
      shipping: file.shipping,
      iva_aliquot: file.iva_aliquot,
      detail: file.sale_type 
    }
  end

  def index_by_company
      render json: current_company.agreement_surgery_files.search(params[:q]).map{|file| {id: file.id, text: file.full_name}}
    end

	def file_params
		params.require(:agreement_surgeries_file).permit(:entity_id, :external_number, :doctor,
			:detail, :province, :pacient, :pacient_number, :place, :title, :init_date,
		:note_original_filename, :note, :sticker_original_filename, :sticker,
		:need_surgical_sheet, :need_implant, :need_sticker, :need_note,
			:finish_date, :open, :substate, :iva_aliquot, :user_id, :initial_department,
			:surgery_end_date, :external_purchase_order_number, :external_shipment_number, :implant_original_filename,
			:implant_certificate, :surgical_sheet, :surgical_sheet_original_filename,
		:implant_state, :surgical_sheet_state,
		:delivery_date, :delivery_hour, :technical,
    :first_name,
    :last_name,
    :document_type,
    :document_number,
    :address,
    :birthday,
    :age,
    :gender,
    :mobile_phone,
    :province,
    :locality,
    :request_date,
    :surgery_type,
    :surgery_date,
    :social_work,
    :pacient_number,
    :medical_history,
    :institution,
    :doctor,
    :internal_stock,
    :surgery_time,
    :observation,
		responsables_attributes: [:id, :document_type, :user_id, :destroy]
		)
	end
end