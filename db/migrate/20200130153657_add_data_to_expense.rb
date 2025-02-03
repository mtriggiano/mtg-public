class AddDataToExpense < ActiveRecord::Migration[5.2]
  def change
    add_reference :expenses, :cash_account, foreign_key: true
    add_column :expenses, :forma, :string
  end
end
