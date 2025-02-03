class RemoveProductSupplierCodeFromDevolutionDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :devolution_details, :product_supplier_code, :string
  end
end
