class AddActiveToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :active, :boolean, null: false, default: true
  end
end
