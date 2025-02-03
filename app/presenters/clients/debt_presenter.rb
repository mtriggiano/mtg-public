class DebtPresenter < Reports::BillPresenter
	presents :bill
	delegate_missing_to :bill

  def external_file_number
    bill.dig(:file, :external_number)
  end

	def total_left
		bill.is?(:credit_note) ? 0 : bill.real_total_left
	end
end
