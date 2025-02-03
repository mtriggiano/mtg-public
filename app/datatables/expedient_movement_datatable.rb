class ExpedientMovementDatatable < ApplicationDatatable

	def get_raw_records
  	 @collection.includes(:sender, :receiver, :department).references(:sender, :receiver, :department)
	end
end
