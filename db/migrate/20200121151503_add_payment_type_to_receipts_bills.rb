class AddPaymentTypeToReceiptsBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :receipts_bills, :payment_type, foreign_key: true
    remove_column :receipts_bills, :payment_type
  end
end
