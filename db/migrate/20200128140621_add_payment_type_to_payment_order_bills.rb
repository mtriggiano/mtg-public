class AddPaymentTypeToPaymentOrderBills < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_order_bills, :payment_type, :string
  end
end
