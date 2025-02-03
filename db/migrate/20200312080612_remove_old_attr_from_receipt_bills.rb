class RemoveOldAttrFromReceiptBills < ActiveRecord::Migration[5.2]
  def change
    remove_reference :receipts_bills, :payment_type, foreign_key: true
    remove_column :receipts_bills, :due_date, :string
    remove_column :receipts_bills, :number, :string
  end
end
