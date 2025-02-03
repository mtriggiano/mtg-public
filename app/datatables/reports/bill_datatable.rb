class Reports::BillDatatable < ApplicationDatatable

	def data
  	records.map do |record|
  		presenter = Reports::BillPresenter.new(record, @view)
  		result = Hash.new
    	DatatableConstants::Reports::Bill.keys.map do |col|
    		result[col.to_sym] = eval("presenter.#{col}")
    	end
    	result[:actions] = presenter.action_links
			result[:DT_RowId] = record.id
    	result
  	end
	end

	def view_columns
		@view_columns = Hash.new
		DatatableConstants::Reports::Bill.map do |k, v|
			@view_columns[k.to_sym] = v.except(:name)
		end
		@view_columns[:links] = {}
		return @view_columns
	end

	def get_raw_records
		@collection
		.includes(:receipts, :expedient_file, :payment_type, :sellers, entity: :province)
		.references(:receipts, :expedient_file, :payment_type, :sellers, entity: :province)
		.where(flow: 'income', state: ['Aprobado', 'Confirmado', 'Anulado']).distinct("bills.id")
	end
end
