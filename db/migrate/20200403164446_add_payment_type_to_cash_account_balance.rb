class AddPaymentTypeToCashAccountBalance < ActiveRecord::Migration[5.2]
  def change
    #add_reference :cash_account_balances, :payment_type, foreign_key: true
    #remove_column :cash_account_balances, :forma
  end
end
