class ChangeReceiptsDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column :receipts, :date, :date, null: false
  end
end
