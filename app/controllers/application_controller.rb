class ApplicationController < ActionController::Base
	before_action :authenticate_user!
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_table_params
	helper_method :current_company
	before_action :set_paper_trail_whodunnit
	respond_to :js, :html, :json, :pdf
	load_and_authorize_resource unless: :devise_controller?, except: [:get_padron, :eventos]

	def authenticate_admin_user!
		redirect_to root_path, alert: "No posee los permisos para acceder a esta sección." unless (user_signed_in? && current_user.is_an_admin?)
	end

	def eventos
		render json: Anmat::EVENTOS[current_company.anmat_type].select{|s| s[:from] == params[:extra_data] && s[:to] == params[:secondary_data]}
	end

	def authenticate_company_owner!
		redirect_to root_path unless user_signed_in? && current_user.is_a_company_owner?
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:company_owner])
		devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :first_name, :last_name, :document_type, :document_number, :birthday, :address, :postal_code, :phone, :mobile_phone])
		devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name])
	end

	def get_padron
		render json: Padron::Call.new(environment: :production, id: params[:data]).get_data.compact.first
	end

	def set_s3_direct_post
  	@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_type_starts_with: '')

	end

	def get_provinces
		render json: Province.where(country_id: params[:country_id]).order(:name).map{|l| {id: l.id, text: l.name}}
	end

	def get_localities
		render json: Locality.where(province_id: params[:province_id]).order(:name).map{|l| {id: l.id, text: l.name}}
	end

	def current_company
		authenticate_user!
		current_user.company if user_signed_in?
	end

	def after_sign_out_path_for(resource_or_scope)
    	new_user_session_path()
	end

	rescue_from CanCan::AccessDenied do |exception|
		current_action = exception.action == :index ? :read : exception.action
		subject = exception.subject.is_a?(Class) ? exception.subject.name : exception.subject.class.name
    	respond_to do |format|
    		format.json { head :forbidden, content_type: 'text/html' }
    		format.html { redirect_to forbidden_path(current_action: current_action, subject: subject), notice: "No estás autorizado para acceder a esta sección." }
    		format.js   { head :forbidden, content_type: 'text/html' }
    	end
	end

	private

	def set_table_params
		params["columns"] ||= { "0" => {"data" => "" } }
		params["length"]  ||= -1
	end
end
