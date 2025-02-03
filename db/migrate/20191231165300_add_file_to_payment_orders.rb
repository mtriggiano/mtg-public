class AddFileToPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_orders, :file, foreign_key: true
  end
end
