class AddIndexToBillsType < ActiveRecord::Migration[5.2]
  def change
    add_index :bills, :type
  end
end
