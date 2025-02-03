class AddDescriptionToBudgetDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :description, :text
  end
end
