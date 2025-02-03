class AddSupplierProductToBatches < ActiveRecord::Migration[5.2]
  def change
    add_reference :batches, :supplier_product, foreign_key: true
    remove_column :batches, :product_id, foreign_key: true
  end
end
