class AddTotalUsdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :total_usd, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :usd_price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
