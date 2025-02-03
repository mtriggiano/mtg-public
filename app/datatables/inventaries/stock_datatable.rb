class StockDatatable < AjaxDatatablesRails::ActiveRecord
  	extend Forwardable

  	def initialize(params, opts = {})
    	@view = opts[:view_context]
    	@store ||= opts[:store]
    	super
  	end

  	def view_columns
	    # Declare strings in this format: ModelName.column_name
	    # or in aliased_join_table.column_name format
	    @view_columns ||= {
	      	id:           		{ source: "Stock.id", cond: :eq },
	      	product:      		{ source: "Porduct.name", cond: :like },
	      	available: 		  	{ source: "Stock.available", cond: :like},
	      	reserved:    		{ source: "Stock.reserved", cond: :like},
	      	waiting_arraival:   { source: "Stock.waiting_arraival", cond: :like},
	      	links: {}
	    }
  	end

  	def data
	  	records.map do |record|
	      	presenter = StockPresenter.new(record, @view)
	    	{
		      	id:           		record.id,
		      	product: 			presenter.product,
		      	available: 			presenter.available,
		      	reserved: 			presenter.reserved,
		      	waiting_arraival: 	presenter.waiting_arraival,
		        actions:        	presenter.action_links
	    	}
	  	end
	end

	def get_raw_records
  	 	@store.stocks.joins(:product).references(:product)
	end
end