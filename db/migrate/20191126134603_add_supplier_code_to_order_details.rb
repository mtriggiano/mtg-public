class AddSupplierCodeToOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :order_details, :product_supplier_code, :string
  end
end
