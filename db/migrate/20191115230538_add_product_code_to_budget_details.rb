class AddProductCodeToBudgetDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_details, :product_code, :string
  end
end
