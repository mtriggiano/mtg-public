class Surgeries::SaleOrderDatatable < ApplicationDatatable
	def get_raw_records
    	@collection.joins(:client, :file)
  	end
end
