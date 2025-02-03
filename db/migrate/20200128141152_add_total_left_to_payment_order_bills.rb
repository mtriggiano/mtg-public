class AddTotalLeftToPaymentOrderBills < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_order_bills, :total_left, :float, null: false, default: 0
  end
end
