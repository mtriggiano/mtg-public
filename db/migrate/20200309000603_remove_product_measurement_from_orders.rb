class RemoveProductMeasurementFromOrders < ActiveRecord::Migration[5.2]
  def change
    change_column :order_details, :product_measurement, :string, null: false, default: "Unidad"
  end
end
