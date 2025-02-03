class AddNoteToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :note, :text
  end
end
