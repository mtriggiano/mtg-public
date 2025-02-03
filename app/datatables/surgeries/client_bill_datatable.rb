class Surgeries::ClientBillDatatable < ApplicationDatatable
	def get_raw_records
    	@collection.joins("LEFT JOIN files ON files.id = bills.file_id")
			.joins("LEFT JOIN entities ON entities.id = bills.entity_id")
	    .joins("LEFT JOIN budgets ON budgets.file_id = files.id")
	    .joins("LEFT JOIN users ON users.id = budgets.seller_id")
  	end
end
