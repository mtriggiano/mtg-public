class AddTotalUsdToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :total_usd, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :bills, :usd_price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
