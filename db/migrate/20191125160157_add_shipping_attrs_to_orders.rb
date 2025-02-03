class AddShippingAttrsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :shipping_price, :float, default: 0.0
    add_column :orders, :shipping_included, :boolean, default: false
  end
end
