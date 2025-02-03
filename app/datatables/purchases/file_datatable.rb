class Purchases::FileDatatable < ApplicationDatatable
	def get_raw_records
  	 @collection.joins(:user)
	end
end
