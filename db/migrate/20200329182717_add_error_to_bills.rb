class AddErrorToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :afip_error, :text
  end
end
