class AddObservationToReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts, :observation, :text
  end
end
