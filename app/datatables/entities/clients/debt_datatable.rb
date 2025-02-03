class Entities::Clients::DebtDatatable < ApplicationDatatable
  def view_columns
		@view_columns = Hash.new
		DatatableConstants::ClientDebt.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def data
	  	records.map do |record|
	  		presenter = DebtPresenter.new(record, @view)
	  		result = Hash.new
	    	DatatableConstants::ClientDebt.keys.map do |col|
	    		result[col.to_sym] = eval("presenter.#{col}")
	    	end
	    	result[:actions] = presenter.action_links
				result[:DT_RowId] = record.id
	    	result
	  	end
	end
  def get_raw_records
    @collection.joins(:expedient_file, :entity).order(total_left: :desc)
  end

end
