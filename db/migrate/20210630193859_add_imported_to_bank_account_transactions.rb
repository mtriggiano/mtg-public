class AddImportedToBankAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_account_transactions, :imported, :boolean, default: false
  end
end
