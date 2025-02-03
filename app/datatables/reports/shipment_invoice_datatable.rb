class Reports::ShipmentInvoiceDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::ShipmentPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::Shipping.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Shipping.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
			.includes(:client).references(:client)
			.includes(file: { expedient_orders: { all_details: :seller } })
			.includes(:consumptions)
			.includes(:location)
			.includes(:user)
			.includes(:expedient_bills)
			.where(state: ["Aprobado", "Confirmado", "Anulado"])
			.distinct("shipments.id")
			.order("shipments.created_at ASC")
	end
end
