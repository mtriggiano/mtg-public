class Reports::PurchaseDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Reports::PurchasePresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Reports::Purchase.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Purchase.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
    .includes(:payment_orders, entity: :province)
		.references(entity: :province)
		.where(state: ['Aprobado', 'Confirmado', 'Anulado']).distinct("bills.id")
	end
end
