class AddPurchaseOrderToPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_orders, :order, foreign_key: true
  end
end
