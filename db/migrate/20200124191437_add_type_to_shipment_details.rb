class AddTypeToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :type, :string
  end
end
