class AgreementSurgeries::SurgeryRequestDatatable < ApplicationDatatable
	def get_raw_records
  	 	@collection.includes(:user, :created_by).references(:users)
	end
end
