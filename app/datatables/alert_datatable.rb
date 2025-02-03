class AlertDatatable < ApplicationDatatable
	def get_raw_records
		#@collection.joins(:users).select("alerts.*, concat(users.first_name, ', ', users.last_name) as user_name")
		@collection
	end
end
