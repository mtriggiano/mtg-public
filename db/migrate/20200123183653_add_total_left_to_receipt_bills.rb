class AddTotalLeftToReceiptBills < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts_bills, :total_left, :float, null: false, default: 0
  end
end
