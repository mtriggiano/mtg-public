class Reports::SupplierRequestDatatable < ApplicationDatatable

	def data
	  	records.map do |record|
	  		presenter = Surgeries::SupplierRequestPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::Surgeries::SupplierRequest.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Surgeries::SupplierRequest.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection.includes(:file, :supplier).distinct("requests.id")
	end
end
