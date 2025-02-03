class AddIdToArrivalOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :arrivals_orders, :id, :primary_key
  end
end
