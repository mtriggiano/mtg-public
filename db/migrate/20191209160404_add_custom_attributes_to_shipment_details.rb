class AddCustomAttributesToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :custom_attributes, :hstore
  end
end
