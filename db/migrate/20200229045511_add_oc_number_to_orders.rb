class AddOcNumberToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :oc_number_from_os, :string
  end
end
