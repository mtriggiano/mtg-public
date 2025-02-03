class AddIdToOrdersShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :orders_shipments, :id, :primary_key
  end
end
