class AddTypeToReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts, :type, :string
  end
end
