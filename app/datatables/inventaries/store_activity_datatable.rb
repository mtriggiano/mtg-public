class StoreActivityDatatable < AjaxDatatablesRails::ActiveRecord
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
	      	id:        	{ source: "StoreActivity.id", cond: :eq },
	      	line:      	{ source: "StoreLine.name", cond: :like },
	      	name: 		{ source: "StoreActivity.name", cond: :like},
	      	date: 		{ source: "StoreActivity.date", cond: :eq},
	      	user: 		{ source: "User.last_name", cond: :like},
	      	links: 		{}
	    }
  	end

  	def data
	  	records.map do |record|
	  		presenter = StoreActivityPresenter.new(record, @view)
	    	{
		      	id:           	record.id,
		      	line: 			presenter.line,
		      	name: 			presenter.name,
		      	date: 			presenter.date,
		      	user: 			presenter.date,
		        actions:        presenter.action_links
	    	}
	  	end
	end

	def get_raw_records
  	 	@external_store.activities.joins(:user).references(:user)
	end
end