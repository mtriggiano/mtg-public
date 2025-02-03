class AddProductSupplierCodeToRequestDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :request_details, :product_supplier_code, :string
  end
end
