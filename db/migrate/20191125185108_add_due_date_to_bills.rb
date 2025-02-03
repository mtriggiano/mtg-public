class AddDueDateToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :due_date, :date
  end
end
