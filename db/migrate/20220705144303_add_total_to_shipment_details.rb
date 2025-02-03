class AddTotalToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :total, :float, default: 0.0
  end
end
