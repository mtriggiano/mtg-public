class AddDataToBankAccountTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_account_transactions, :cuerpo_descripcion, :text
    add_reference :bank_account_transactions, :user, foreign_key: true
  end
end
