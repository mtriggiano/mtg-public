class AddCustomDetailToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :custom_detail, :boolean, null: false, default: false
  end
end
