class AddIdToOrdersRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :orders_requests, :id, :primary_key
  end
end
