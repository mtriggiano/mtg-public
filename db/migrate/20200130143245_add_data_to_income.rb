class AddDataToIncome < ActiveRecord::Migration[5.2]
  def change
    add_reference :incomes, :cash_account, foreign_key: true
    add_column :incomes, :forma, :string
  end
end
