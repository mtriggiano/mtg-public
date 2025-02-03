class ChangeReceiptsDefaults2 < ActiveRecord::Migration[5.2]
  def change
    change_column :receipts, :date, :date, default: nil, null: false
  end
end
