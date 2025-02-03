class Inventaries::BatchDatatable < ApplicationDatatable

  	def get_raw_records
    	@collection.preload(batch_stores: :store).order(default: :desc, quantity: :desc)
  	end

end
