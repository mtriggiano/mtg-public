class AddIdToBillsOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :bills_orders, :id, :primary_key
  end
end
