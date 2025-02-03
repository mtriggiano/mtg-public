class AddSendedQuantityToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :sended_quantity, :float, null: false, default: 0.0
  end
end
