class AddIvaAttrsToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :fecha_registro, :date
    add_column :expense_details, :percep_iva, :decimal
  end
end
