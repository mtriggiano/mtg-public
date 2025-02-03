class AddBankAccountToEmittedChecks < ActiveRecord::Migration[5.2]
  def change
    add_column :emitted_checks, :bank_account_id, :bigint
  end
end
