class AddCompanyToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_reference :expense_details, :company, foreign_key: true
  end
end
