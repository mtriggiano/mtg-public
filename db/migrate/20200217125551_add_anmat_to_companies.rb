class AddAnmatToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :anmat_user, :string
    add_column :companies, :anmat_password, :string
  end
end
