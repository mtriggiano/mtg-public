class AddBankAccountToReceiptPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :receipts_payments, :bank_account, foreign_key: true
  end
end
