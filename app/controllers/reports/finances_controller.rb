class Reports::FinancesController < ApplicationController
	load_and_authorize_resource class: 'Reports::Finance', except: [:index]
	skip_load_and_authorize_resource only: [:index]
  
	expose :emitted_checks, -> { current_company.emitted_checks }
  
	def index
	  authorize! :access, :reports
  
	  if request.format.json?
		render json: Reports::EmittedCheckDatatable.new(params, view_context: view_context, collection: emitted_checks), status: 200
	  end
	end
  end
  