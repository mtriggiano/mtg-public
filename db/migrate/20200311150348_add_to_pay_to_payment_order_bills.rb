class AddToPayToPaymentOrderBills < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_order_bills, :previous_total_left, :decimal, precision: 10, scale: 2
  end
end
