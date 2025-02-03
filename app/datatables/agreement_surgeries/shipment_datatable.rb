class AgreementSurgeries::ShipmentDatatable < ApplicationDatatable
	def get_raw_records
  	 	@collection.includes(:user, :client, :file).references(:users)
	end
end
