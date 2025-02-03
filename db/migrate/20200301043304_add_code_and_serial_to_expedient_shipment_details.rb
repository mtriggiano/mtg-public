class AddCodeAndSerialToExpedientShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :code, :string
    add_column :shipment_details, :serial, :string
    add_column :shipment_details, :due_date, :string
  end
end
