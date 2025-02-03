class AddOnlyIvaToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
  	add_column :shipment_details, :iva, :decimal, precision: 10, scale: 2, null: false, default: 0.21
  end
end
