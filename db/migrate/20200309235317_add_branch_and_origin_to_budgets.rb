class AddBranchAndOriginToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :branch, :string
    add_column :budget_details, :source, :string
  end
end
