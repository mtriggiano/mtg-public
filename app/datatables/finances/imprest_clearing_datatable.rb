class Finances::ImprestClearingDatatable < ApplicationDatatable
	def get_raw_records
		@collection.includes(:general_cash_account, :regular_cash_account, :user).references(:general_cash_account, :regular_cash_account, :user)
	end
end