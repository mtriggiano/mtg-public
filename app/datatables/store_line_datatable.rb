class StoreLineDatatable < AjaxDatatablesRails::ActiveRecord
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
	      	id:        { source: "StoreLine.id", cond: :eq },
	      	name:      { source: "StoreLine.name", cond: :like },
	      	created_at: { source: "StoreLine.created_at", cond: :eq},
	      	links: {}
	    }
  	end

  	def data
	  	records.map do |record|
	  		presenter = StoreLinePresenter.new(record, @view)
	    	{
		      	id:           	record.id,
		      	name: 			presenter.name,
		      	created_at: 	presenter.created_at,
		        actions:        presenter.action_links
	    	}
	  	end
	end

	def get_raw_records
  	 	@external_store.lines
	end
end