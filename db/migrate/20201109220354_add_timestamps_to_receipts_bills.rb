class AddTimestampsToReceiptsBills < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts_bills, :updated_at, :datetime
  end
end
