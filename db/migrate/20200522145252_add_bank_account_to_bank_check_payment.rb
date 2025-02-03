class AddBankAccountToBankCheckPayment < ActiveRecord::Migration[5.2]
  def change
    add_reference :promissory_payments, :bank_account, foreign_key: true
  end
end
