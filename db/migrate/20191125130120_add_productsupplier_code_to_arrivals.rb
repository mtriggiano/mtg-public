class AddProductsupplierCodeToArrivals < ActiveRecord::Migration[5.2]
  def change
    add_column :arrival_details, :product_supplier_code, :string
  end
end
