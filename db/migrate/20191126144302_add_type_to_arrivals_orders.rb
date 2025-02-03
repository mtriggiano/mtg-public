class AddTypeToArrivalsOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :arrivals_orders, :type, :string
  end
end
