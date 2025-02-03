class CompaniesController < ApplicationController
	before_action :authenticate_admin_user!, only: [:index, :destroy]
	before_action :authenticate_company_owner!, only: [:edit, :update]
	before_action :set_s3_direct_post
	before_action :set_current_view

	exposure_config :current_user_strategy, find: ->(id, scope){
		authenticate_user!
	    company = scope.find(id)
	    raise ActiveRecord::RecordNotFound unless current_user.company == company
	    company
	}

	expose :company, with: :current_user_strategy

	def show; end

	def edit; end

	def new; end

	def create
		if company.save && current_user.assign_company(company.id)
			redirect_to edit_company_path(company.id, view: current_view), notice: "Actualizacion exitosa"
		else
			pp company.errors
			redirect_to request.referer, notice: ""
		end
	end

	def update
		if company.update(company_params)
			redirect_to edit_company_path(company.id, view: current_view), notice: "Actualizacion exitosa"
		else
			pp company.errors
			@view = params[:company][:view]
			render :edit
		end
	end

	def destroy
		if company.destroy
			redirect_to companies_path
		else
			render :index
		end
	end

	def vendor_charts
		render json: ChartManager::UserChartDataObtainer.new(current_company.users, false, params[:init_date].to_date, params[:final_date].to_date).get_list_by_user_and_month.chart_json
	end

	def vendor_client_charts
	  render json: ChartManager::UserChartDataObtainer.new(current_company.users, false, params[:init_date].to_date, params[:final_date].to_date).get_client_list
	end

	def vendor_charts_quantity
	  render json: ChartManager::UserChartDataObtainer.new(current_company.users, false, params[:init_date].to_date, params[:final_date].to_date).perform.chart_json
	end

	def vendor_client_charts_quantity
	  render json: ChartManager::UserChartDataObtainer.new(current_company.users, false, params[:init_date].to_date, params[:final_date].to_date).get_client_list_quantity.chart_json
	end

	def charts_filter
	  # code
	end

private
	def company_params
		params.require(:company).permit(:logo, :name, :email, :society_name, :concept, :activity_init_date, :currency, :contact_number, :cbu, :gross_income, :cuit, :iva_cond, :coefficient_for_net_amount,:locality_id, :postal_code, :address, :pdf_logo,
			:anmat_user, :anmat_password, :gln, :anmat_type,
			sale_points_attributes: [:id, :number, :_destroy],
			departments_attributes: [:id, :name, :user_id, :_destroy],
			stores_attributes: [:id, :name, :location, :filled, :_destroy],
			banks_attributes: [:id, :name, :cbu, :account_number, :_destroy],
			cards_attributes: [:id, :name, :card_type, :one_payment_delay, :installments_delay, :delay_type, :bank_id, :_destroy]
		)
	end

	def current_view
		params[:company].try(:[], 'view')
	end

	def set_current_view
		company.current_view = current_view
	end
end
