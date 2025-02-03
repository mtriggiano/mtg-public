class Tenders::FileMovementDatatable < ApplicationDatatable
	def get_raw_records
  	 	@collection.includes(:sender, :receiver, :department)
	end
end
