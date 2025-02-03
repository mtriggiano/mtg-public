class AddTributesToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :no_gravados, :decimal, precision: 10, scale: 2
    add_column :expense_details, :percep_iibb, :decimal, precision: 10, scale: 2
  end
end
