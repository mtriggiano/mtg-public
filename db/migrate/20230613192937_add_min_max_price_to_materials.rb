class AddMinMaxPriceToMaterials < ActiveRecord::Migration[5.2]
  def change
  	add_column :surgery_materials, :minimum_price, :decimal, precision: 10, scale: 2, default: "0.0"
  	add_column :surgery_materials, :maximum_price, :decimal, precision: 10, scale: 2, default: "0.0"
  	add_column :surgery_materials, :code, :string
  end
end
