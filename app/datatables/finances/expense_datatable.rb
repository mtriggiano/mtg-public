class Finances::ExpenseDatatable < ApplicationDatatable
	def get_raw_records
		@collection
	end
end