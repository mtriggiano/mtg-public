class AddBankAccountToPaymentOrderPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_order_payments, :bank_account, foreign_key: true
  end
end
