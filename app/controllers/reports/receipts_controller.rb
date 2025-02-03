class Reports::ReceiptsController < ApplicationController
	load_and_authorize_resource class: 'Reports::Receipt', except: [:index]
	skip_load_and_authorize_resource only: [:index]
  
	def index
	  authorize! :access, :reports
  
	  @receipts = current_company.expedient_receipts.report_search(params)
	end
  end
  