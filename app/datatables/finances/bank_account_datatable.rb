class BankAccountDatatable < ApplicationDatatable
	def get_raw_records
		@collection
			.includes(:emited_checks, :bank_check_payments, :bank_transfer_payments, :emitted_transfer_payments)
			.references(:emited_checks, :bank_check_payments, :bank_transfer_payments, :emitted_transfer_payments)
			.collection
	end
end