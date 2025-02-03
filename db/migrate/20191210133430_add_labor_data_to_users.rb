class AddLaborDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :contract, :string
    add_column :users, :talliable, :boolean, default: true
  end
end
