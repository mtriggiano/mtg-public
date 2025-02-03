class Reports::ConsumptionDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::ConsumptionPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::Consumption.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Consumption.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
      .joins("LEFT JOIN files ON shipments.file_id = files.id")
      .joins("LEFT JOIN consumptions_shipments ON consumptions_shipments.consumption_id = shipments.id LEFT JOIN shipments as real_shipments ON consumptions_shipments.shipment_id = real_shipments.id")
      .joins("LEFT JOIN orders_shipments ON real_shipments.id = orders_shipments.shipment_id LEFT JOIN orders as sale_orders ON sale_orders.id = orders_shipments.order_id")
      .joins("LEFT JOIN entities ON shipments.entity_id = entities.id")
      .joins("LEFT JOIN orders as purchase_orders ON purchase_orders.id = orders_shipments.order_id")
      .distinct("shipments.id")
	end
end
