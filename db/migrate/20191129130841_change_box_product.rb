class ChangeBoxProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :box_products, :cirgury_box_id, :bigint
    add_column :box_products, :box_id, :bigint, null: false

    add_index :box_products, [:box_id, :product_id], unique: true
  end
end
