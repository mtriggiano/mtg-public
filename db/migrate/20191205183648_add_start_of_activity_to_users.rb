class AddStartOfActivityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :start_of_activity, :date
  end
end
