class AddCompanyToReceivedBankChecks < ActiveRecord::Migration[5.2]
  def change
    add_reference :received_bank_checks, :company, foreign_key: true
  end
end
