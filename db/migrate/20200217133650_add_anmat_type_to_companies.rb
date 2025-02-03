class AddAnmatTypeToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :anmat_type, :string
  end
end
