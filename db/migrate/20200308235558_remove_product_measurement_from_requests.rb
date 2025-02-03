class RemoveProductMeasurementFromRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :request_details, :product_measurement, :string
    add_column :request_details, :product_measurement, :string, null: false, default: "Unidad"
  end
end
