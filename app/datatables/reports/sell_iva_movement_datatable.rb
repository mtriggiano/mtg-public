class Reports::SellIvaMovementDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::SellIvaMovementPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::SellIvaMovement.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::SellIvaMovement.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
		.joins("LEFT JOIN entities ON entities.id = bills.entity_id")
		.joins("LEFT JOIN provinces ON provinces.id = entities.province_id")
		.includes(:entity, :tributes)
		.distinct("bills.id")
		.order("bills.created_at asc")
	end
end
