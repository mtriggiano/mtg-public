class CreateJoinTableProductsSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_products do |t|
      t.references :entity, foreign_key: true
      t.references :product, foreign_key: true
      t.boolean :traceable, null: false, default: false

      t.timestamps
    end

    add_index :supplier_products, [:product_id, :entity_id], unique: true
  end
end
