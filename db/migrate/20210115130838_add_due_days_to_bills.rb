class AddDueDaysToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :due_days, :integer
  end
end
