class AddLabelsToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :recibe, :string
    add_column :expense_details, :representa, :string
  end
end
