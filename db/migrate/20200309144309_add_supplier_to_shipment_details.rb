class AddSupplierToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_reference :shipment_details, :entity, foreign_key: true
  end
end
