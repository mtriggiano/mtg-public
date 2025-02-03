class AddIdToOrdersBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :orders_budgets, :id, :primary_key
  end
end
