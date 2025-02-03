class AddReferencesToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_reference :expense_details, :order, foreign_key: true
  end
end
