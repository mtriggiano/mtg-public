class AddPaymentTypeReferenceToPaymentOrderBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_order_bills, :payment_type, foreign_key: true
    add_reference :payment_order_bills, :checkbook, foreign_key: true
  end
end
