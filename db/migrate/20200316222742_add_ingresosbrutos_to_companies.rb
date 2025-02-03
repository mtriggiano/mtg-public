class AddIngresosbrutosToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :gross_income, :string
  end
end
