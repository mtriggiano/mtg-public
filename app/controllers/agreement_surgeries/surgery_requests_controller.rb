class AgreementSurgeries::SurgeryRequestsController < ApplicationController
  expose :surgery_requests, ->{current_company.surgery_requests}
  expose :surgery_request, scope: -> {surgery_requests}, model: "AgreementSurgeries::SurgeryRequest"

  before_action :set_surgery_request, only: [:rechazar, :aprobar, :pre_rechazar]
  before_action :set_s3_direct_post, only: [:show, :new, :edit, :create, :update, :aprobar, :coordinar]

  include Indexable
  include BasicCrud

  def create
    authorize! :create, surgery_request
    surgery_request.current_user = current_user
    surgery_request.created_by = current_user
    respond_to do |format|
      if surgery_request.save
        format.html { redirect_to surgery_request, notice: "Solicitud creada con exito" }
      else
        pp surgery_request.errors
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, surgery_request
    surgery_request.current_user = current_user
    surgery_request.updated_by = current_user
    respond_to do |format|
      if surgery_request.update(surgery_request_params)
        format.html { redirect_to surgery_request, notice: "Solicitud actualizada con éxito" }
      else
        format.html { render :edit }
      end
    end
  end

  def pre_rechazar
  end

  def rechazar
    reason = surgery_request_rejection_params[:reason_for_rejection]
    if surgery_request.rechazar(current_user, reason)
      redirect_to surgery_request, notice: "Solicitud fue rechazada correctamente"
    else
      render :pre_rechazar
    end
  end

  def aprobar
    if surgery_request.aprobar(current_user)
      redirect_back(fallback_location: root_path, notice: "Solicitud fue aprobada correctamente")
    else
      render :edit
    end
  end

  def coordinar
    if surgery_request.coordinar(current_user)
      redirect_back(fallback_location: root_path, notice: "Solicitud fue coordinada correctamente")
    else
      pp surgery_request.errors if Rails.env == "development"
      render :edit
    end
  end

  def recuperar
    if surgery_request.recuperar(current_user)
      redirect_back(fallback_location: root_path, notice: "Solicitud fue recuperda correctamente")
    else
      pp surgery_request.errors if Rails.env == "development"
      render :edit
    end
  end

  def a_espera_procesamiento
    if surgery_request.a_espera_procesamiento!
      redirect_back(fallback_location: root_path, notice: "Solicitud fue recuperda correctamente")
    else
      pp surgery_request.errors if Rails.env == "development"
      render :edit
    end
  end

  def crear_expediente
    file = surgery_request.create_file(current_user)
    if file.save
      redirect_to file, notice: "Expediente creado correctamente"
    else
      pp surgery_request.errors if Rails.env == "development"
      render :edit
    end
  end

  private
    def set_surgery_request
      surgery_request = AgreementSurgeries::SurgeryRequest.find(params[:id])  
    end

    def surgery_request_rejection_params
      params.require(:agreement_surgeries_surgery_request).permit(
        :reason_for_rejection,
      )
    end

  	def surgery_request_params
  	  params.require(:agreement_surgeries_surgery_request).permit(
        :company,
        :request_date,
        :surgery_type,
        :surgery_date,
        :observation,
        :first_name,
        :last_name,
        :birthday,
        :age,
        :gender,
        :document_type,
        :document_number,
        :address,
        :mobile_phone,
        :phone,
        :province_id,
        :locality_id,
        :social_work,
        :pacient_number,
        :medical_history,
        :institution,
        :doctor,
        :internal_stock,
        :dni,
        :anses_negative,
        :surgery_time, 
        :right_limb, 
        :left_limb, 
        :surgical_site,
        :nationality,
        :dni,
        :anses_negative,
        :anses_no_negative,
        :surgical_sheet,
        :codem,
        :clinical_record_cover,
        :implant_certificate,
        :father_dni,
        :mother_dni,
        :father_anses_negative,
        :mother_anses_negative,
        surgery_request_details_attributes: [
          :id, 
          :surgery_material, 
          :quantity,
          :_destroy
        ],
      )
  	end
end