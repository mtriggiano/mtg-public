class AddDefaultProductMeasurementToArrivalDetails < ActiveRecord::Migration[5.2]
  def change
  	remove_column :arrival_details, :product_measurement, :string
    add_column :arrival_details, :product_measurement, :string, null: false, default: "Unidad"
  end
end
