class Surgeries::FileDatatable < ApplicationDatatable

	def get_raw_records
  	 	@collection
				.joins(:user)
				.joins("LEFT OUTER JOIN entities on files.entity_id = entities.id")
				.joins("LEFT OUTER JOIN budgets on budgets.file_id = files.id LEFT OUTER JOIN users sellers on budgets.seller_id = sellers.id")
				.distinct("files.id")
				
	end
end
