class Reports::ArrivalDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::ArrivalPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::Arrival.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Arrival.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
      .joins("LEFT JOIN bill_arrivals ON arrivals.id = bill_arrivals.arrival_id LEFT JOIN bills ON bill_arrivals.bill_id = bills.id")
      .joins("LEFT JOIN entities ON arrivals.entity_id = entities.id")
      .joins("LEFT JOIN arrivals_orders ON arrivals.id = arrivals_orders.arrival_id LEFT JOIN orders ON arrivals_orders.order_id = orders.id")
      .joins("LEFT JOIN files ON orders.file_id = files.id")
      .joins("LEFT JOIN users ON arrivals.user_id = users.id")
      .distinct("arrivals.id")
	end
end
