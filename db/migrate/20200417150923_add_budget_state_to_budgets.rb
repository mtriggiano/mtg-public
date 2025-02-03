class AddBudgetStateToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :budget_state, :string, default: "Pendiente"
  end
end
