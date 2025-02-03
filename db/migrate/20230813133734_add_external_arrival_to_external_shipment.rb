class AddExternalArrivalToExternalShipment < ActiveRecord::Migration[5.2]
  def change
    add_column :arrivals, :shipment_id, :integer
  end
end
