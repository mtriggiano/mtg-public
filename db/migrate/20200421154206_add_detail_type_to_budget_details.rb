class AddDetailTypeToBudgetDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :detail_type, :string
  end
end
