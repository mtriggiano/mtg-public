class AddProviderToProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :supplier, :string
  end
end
