class ChangeTotalTypeFromExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    change_column :expense_details, :exento, :float, null: false, default: 0
  end
end
