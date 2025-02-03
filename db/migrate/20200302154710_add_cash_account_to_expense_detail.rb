class AddCashAccountToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_reference :expense_details, :cash_account, foreign_key: true
    add_column :expense_details, :type, :string
  end
end
