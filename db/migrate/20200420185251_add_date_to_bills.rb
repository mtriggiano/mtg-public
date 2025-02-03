class AddDateToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :date, :date
  end
end
