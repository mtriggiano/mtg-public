class AddImportedToPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_orders, :imported, :boolean, default: false
  end
end
