class RemoveBoxIndex < ActiveRecord::Migration[5.2]
  def change
  	remove_index :box_products, name: "index_box_products_on_box_id_and_product_id"
  end
end
