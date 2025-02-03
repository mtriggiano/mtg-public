class ResponsableDatatable < ApplicationDatatable

  	def get_raw_records
  		@collection.joins(:user, :file).includes(:file, :user)
  	end
end
