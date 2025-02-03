class AddMachineIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :machine_id, :integer
  end
end
