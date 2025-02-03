class DropTableGtin < ActiveRecord::Migration[5.2]
  def change
    drop_table :gtins
  end
end
