class AddReceiptTypeToExpedientReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts, :receipt_type, :string, default: "normal"
  end
end
