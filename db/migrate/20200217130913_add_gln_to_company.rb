class AddGlnToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :gln, :string
  end
end
