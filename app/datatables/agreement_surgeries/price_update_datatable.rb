class AgreementSurgeries::PriceUpdateDatatable < ApplicationDatatable
	def get_raw_records
  	 	@collection.includes(:created_by).references(:users)
	end
end
