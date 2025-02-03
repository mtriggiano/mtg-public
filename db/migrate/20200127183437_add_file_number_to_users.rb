class AddFileNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :file_number, :bigint
  end
end
