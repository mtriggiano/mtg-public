class AddReturnedToBatchDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :batch_details, :returned, :float, null: false, default: 0
  end
end
