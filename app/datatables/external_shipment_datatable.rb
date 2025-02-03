class ExternalShipmentDatatable < ApplicationDatatable
	def get_raw_records
    	@collection.joins(:client).references(:client)
  	end
end
