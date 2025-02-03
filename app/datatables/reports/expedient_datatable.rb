class Reports::ExpedientDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::ExpedientPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::Expedient.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Expedient.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
		.includes(:entity, :expedient_orders, expedient_orders: :sellers, expedient_shipments: [all_details: :inventary] )
    .references(:entity, :expedient_orders, expedient_orders: :sellers, expedient_shipments: [all_details: :inventary])
    .where(type: ["Surgeries::File", "Sales::File", "Tenders::File"])
	end
end
