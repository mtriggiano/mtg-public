class AddQuantityToBatch < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :quantity, :float, null: false, default: 0
  end
end
