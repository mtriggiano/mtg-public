class Finances::PromissoryPaymentDatatable < ApplicationDatatable

	def get_raw_records
		@collection.includes(:receipt, :client).references(:receipt, :client)
	end
end