class Reports::BuyIvaMovementDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::BuyIvaMovementPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::BuyIvaMovement.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::BuyIvaMovement.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
		.includes(:details, :entity, :tributes)
		.references(:details, :entity, :tributes)
		.order("bills.date ASC")
	end
end
