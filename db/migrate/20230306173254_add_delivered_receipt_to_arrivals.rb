class AddDeliveredReceiptToArrivals < ActiveRecord::Migration[5.2]
  def change
  	add_column :arrivals, :delivered_shipments, :boolean, null: true, default: nil
  end
end
