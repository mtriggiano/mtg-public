class ChangeAttrsExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :expense_details, :cbte_tipo
    add_column :expense_details, :cbte_tipo, :string, default: "01"
  end
end
