class StockRequestDetailDatatable < AjaxDatatablesRails::ActiveRecord
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
	      	id:           		{ source: "StockRequestDetail.id", cond: :eq },
	      	request:      		{ source: "StockRequest.number", cond: :start_with },
	      	user_id:      		{ source: "User.last_name", cond: :like },
	      	product_name:      	{ source: "StockRequestDetail.product_name", cond: :like },
	      	quantity:      		{ source: "StockRequestDetail.quantity", cond: :eq },
	      	urgency:      		{ source: "StockRequestDetail.urgency", cond: :eq },
	      	observation:      	{ source: "StockRequestDetail.observation", cond: :like },
	      	due_date:      		{ source: "StockRequestDetail.due_date", cond: :eq },
	      	state:      		{ source: "StockRequestDetail.state", cond: :like },
	      	state_actions: 		{},
	      	links: {}
	    }
  	end

  	def data
	  	records.map do |record|
	      	presenter = StockRequestDetailPresenter.new(record, @view)
	    	{
		      	id:           		record.id,
		      	request: 			presenter.request,
				user_id: 			presenter.user_id,
				product_name: 		presenter.product_name,
				quantity: 			presenter.quantity,
				urgency: 			presenter.urgency,
				observation: 		presenter.observation,
				due_date: 			presenter.due_date,
				state: 				presenter.state,
				state_actions: 		presenter.state_actions,
				actions:        	presenter.action_links
		      	
	    	}
	  	end
	end

	def get_raw_records
  	 	@external_store.request_details.joins(stock_request: :user).references(stock_request: :user)
	end
end