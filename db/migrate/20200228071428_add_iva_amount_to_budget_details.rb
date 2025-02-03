class AddIvaAmountToBudgetDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :iva_amount, :float, null: false, default: 0
  end
end
