class AddTotalTribToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :total_trib, :float, null: false, default: 0.0
  end
end
