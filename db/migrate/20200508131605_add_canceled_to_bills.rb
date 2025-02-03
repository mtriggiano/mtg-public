class AddCanceledToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :canceled, :boolean, null: false, default: false
  end
end
