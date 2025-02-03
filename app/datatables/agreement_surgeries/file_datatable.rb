class AgreementSurgeries::FileDatatable < ApplicationDatatable
	def get_raw_records
  	 	@collection.includes(:user).references(:users)
	end
end
