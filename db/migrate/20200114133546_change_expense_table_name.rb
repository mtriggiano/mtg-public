class ChangeExpenseTableName < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :general_cash_expenses, :expenses
  end

  def self.down
    rename_table :expenses, :general_cash_expenses
  end
end
