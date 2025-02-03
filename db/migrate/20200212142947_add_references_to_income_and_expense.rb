class AddReferencesToIncomeAndExpense < ActiveRecord::Migration[5.2]
  def change
    add_reference :incomes, :spendable, polymorphic: true
    add_reference :expenses, :spendable, polymorphic: true
  end
end
