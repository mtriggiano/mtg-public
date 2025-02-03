class AddAvailableToReceiptsBills < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts_bills, :available_to_assign, :decimal, null: false, default: 0, scale: 2, precision: 10
  end
end
