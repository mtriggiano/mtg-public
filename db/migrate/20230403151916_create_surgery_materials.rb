class CreateSurgeryMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :surgery_materials do |t|
      t.string :description
      t.string :category
      t.string :origin
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :active, default: true, null: false
      t.decimal :price, precision: 10, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end
