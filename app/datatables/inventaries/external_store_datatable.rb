class ExternalStoreDatatable < AjaxDatatablesRails::ActiveRecord
  	extend Forwardable

  	def initialize(params, opts = {})
    	@view = opts[:view_context]
    	@company ||= opts[:company]
    	@store_type ||= opts[:store_type]
    	super
  	end

  	def view_columns
	    # Declare strings in this format: ModelName.column_name
	    # or in aliased_join_table.column_name format
	    @view_columns ||= {
	      	id:        { source: "Store.id", cond: :eq },
	      	name:      { source: "Store.name", cond: :like },
	      	location:  { source: "Store.location", cond: :like},
	      	filled:    { source: "Store.filled", cond: :eq},
	      	links: {}
	    }
  	end

  	def data
	  	records.map do |record|
	      	presenter = StorePresenter.new(record, @view)
	    	{
		      	id:           	record.id,
		      	name: 			presenter.name,
		      	location: 		presenter.location,
		      	filled:    		presenter.filled,
		        actions:        presenter.action_links
	    	}
	  	end
	end

	def get_raw_records
  	 	@company.external_stores
	end
end