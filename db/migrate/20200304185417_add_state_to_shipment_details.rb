class AddStateToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :state, :boolean, null: false, default: false
  end
end
