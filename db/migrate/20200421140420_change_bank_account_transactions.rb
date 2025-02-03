class ChangeBankAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :bank_account_transactions, :fecha, :date, null: false
    remove_column :bank_account_transactions, :flow
    remove_column :bank_account_transactions, :monto
    add_column :bank_account_transactions, :credito, :decimal, precision: 10, scale: 2, null: false
    add_column :bank_account_transactions, :debito, :decimal, precision: 10, scale: 2, null: false
    remove_column :bank_account_transactions, :cuerpo_descripcion
    remove_reference :bank_account_transactions, :user
  end
end
