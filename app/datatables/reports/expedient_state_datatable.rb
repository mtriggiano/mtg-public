class Reports::ExpedientStateDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::ExpedientPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::ExpedientState.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::ExpedientState.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
		.includes(expedient_orders: :attachments)
    .where(type: ["Surgeries::File", "Sales::File", "Tenders::File"])
    .where(orders: {type: ["Surgeries::SaleOrder", "Sales::Order", "Tenders::Order"]})
	end
end
