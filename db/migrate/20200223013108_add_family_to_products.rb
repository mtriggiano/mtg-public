class AddFamilyToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :family, :string
  end
end
