class CheckbookDatatable < ApplicationDatatable
	def get_raw_records
		@collection.joins(:bank)
	end
end
