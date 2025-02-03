class AddGtinToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :gtin, :string
    add_column :products, :pm, :string
  end
end
