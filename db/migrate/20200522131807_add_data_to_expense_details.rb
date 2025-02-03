class AddDataToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :cbte_tipo, :string, default: "06"
    add_column :expense_details, :exento, :decimal, precision: 10, scale: 2, default: 0
  end
end
