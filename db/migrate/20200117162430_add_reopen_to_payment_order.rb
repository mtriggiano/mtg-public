class AddReopenToPaymentOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_orders, :custom_attributes, :hstore
  end
end
