class AddCustomAttributesToBudgetDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :custom_attributes, :hstore
  end
end
