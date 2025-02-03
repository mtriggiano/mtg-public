class AddSupplierCodeToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :product_supplier_code, :string
  end
end
