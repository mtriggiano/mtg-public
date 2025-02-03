class AddDetailsToReceiptDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts_bills, :number, :string
    add_column :receipts_bills, :due_date, :date
  end
end
