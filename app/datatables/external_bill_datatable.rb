class ExternalBillDatatable < Purchases::BillDatatable
	def get_raw_records
    	@collection.includes(:entity, :credit_notes, :debit_notes).joins(:entity)
  	end
end
