class ExternalArrivalDatatable < ApplicationDatatable
	def get_raw_records
    	@collection.joins(:supplier).references(:supplier)
  	end
end