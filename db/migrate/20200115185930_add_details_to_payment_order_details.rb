class AddDetailsToPaymentOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_order_orders, :number, :string
    add_column :payment_order_orders, :due_date, :date
  end
end
