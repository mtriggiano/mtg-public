class RemoveTypeFromReceipts < ActiveRecord::Migration[5.2]
  def change
    remove_column :receipts, :type, :string
  end
end
