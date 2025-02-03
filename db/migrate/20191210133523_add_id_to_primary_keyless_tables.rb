class AddIdToPrimaryKeylessTables < ActiveRecord::Migration[5.2]
  def change
  	add_column :receipts_bills, :id, :primary_key
  	add_column :suppliers_products, :id, :primary_key
  	add_column :alerts_users, :id, :primary_key
  end
end
