class StockRequestDatatable < AjaxDatatablesRails::ActiveRecord
  	extend Forwardable

  	def initialize(params, opts = {})
    	@view = opts[:view_context]
    	@external_store ||= opts[:external_store]
    	super
  	end

  	def view_columns
	    # Declare strings in this format: ModelName.column_name
	    # or in aliased_join_table.column_name format
	    @view_columns ||= {
	      	id:           		{ source: "StockRequest.id", cond: :eq },
	      	number:      		{ source: "StockRequest.number", cond: :like },
	      	user:      			{ source: "User.last_name", cond: :like },
	      	reason:      		{ source: "StockRequest.reason", cond: :like },
	      	date:      			{ source: "StockRequest.date", cond: :like },
	      	due_date:      		{ source: "StockRequest.due_date", cond: :like },
	      	urgency:      		{ source: "StockRequest.urgency", cond: :eq },
	      	state:      		{ source: "StockRequest.state", cond: :like },
	      	links: {}
	    }
  	end

  	def data
	  	records.map do |record|
	      	presenter = StockRequestPresenter.new(record, @view)
	    	{
		      	id:           		record.id,
		      	number: 			presenter.number,
		      	user: 				presenter.user,
		      	reason: 			presenter.reason,
		      	date: 				presenter.date,
		      	due_date: 			presenter.due_date,
		      	urgency: 			presenter.urgency,
		      	state: 				presenter.state,
		        actions:        	presenter.action_links
	    	}
	  	end
	end

	def get_raw_records
  	 	@external_store.requests.joins(:user).references(:user)
	end
end