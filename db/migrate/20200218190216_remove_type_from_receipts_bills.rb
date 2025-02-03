class RemoveTypeFromReceiptsBills < ActiveRecord::Migration[5.2]
  def change
    remove_column :receipts_bills, :type, :string
  end
end
