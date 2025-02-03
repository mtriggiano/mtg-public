class Sales::FileDatatable < ApplicationDatatable
	def get_raw_records
			@collection
				 .joins(:entity, :user)
				 .joins("LEFT OUTER JOIN budgets on budgets.file_id = files.id LEFT OUTER JOIN users sellers on budgets.seller_id = sellers.id")
				 .distinct("files.id")
	end
end
