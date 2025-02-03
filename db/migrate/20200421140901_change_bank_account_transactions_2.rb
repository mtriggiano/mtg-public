class ChangeBankAccountTransactions2 < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_account_transactions, :saldo, :decimal, precision: 10, scale: 2, null: false
  end
end
