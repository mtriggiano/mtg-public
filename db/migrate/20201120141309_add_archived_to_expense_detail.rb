class AddArchivedToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :archived, :boolean, default: false
  end
end
