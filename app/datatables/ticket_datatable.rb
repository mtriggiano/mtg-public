class TicketDatatable < ApplicationDatatable
	def get_raw_records
		@collection.includes(:user)
	end
end
