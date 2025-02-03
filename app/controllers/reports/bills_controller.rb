# app/controllers/reports/bills_controller.rb
class Reports::BillsController < ApplicationController
	# Usa CanCanCan para manejar la autorización
	load_and_authorize_resource class: 'Reports::Bill', except: :index
  
	expose :bills, -> { current_user.can_see_all_sellers ? current_company.expedient_bills.search_by_id(params[:bill_ids]) : current_company.expedient_bills.search_by_id(params[:bill_ids]).search_by_seller(current_user.id) }
	expose :bill_details, -> { current_company.expedient_bill_details.select_real_total }
	skip_load_and_authorize_resource only: :index
  
	# Asegurando el acceso para la acción 'index'
	def index
	  # Verifica el permiso de acceso a los reportes antes de ejecutar la acción
	  authorize! :access, :reports
  
	  @can_see_all_sellers = current_user.can_see_all_sellers
  
	  if request.format.json? && params[:view] == 'expedients'
		col = Expedient.where(type: ["Surgeries::File", "Sales::File", "Tenders::File"])
		render json: Reports::ExpedientDatatable.new(params, view_context: view_context, collection: col), status: 200
	  elsif request.format.json? && params[:view] == 'expedient_state'
		col = Expedient.where(type: ["Surgeries::File", "Sales::File", "Tenders::File"])
		render json: Reports::ExpedientStateDatatable.new(params, view_context: view_context, collection: col), status: 200
	  elsif request.format.json?
		render json: Reports::BillDatatable.new(params, view_context: view_context, collection: bills), status: 200
	  end
	end
  end
  