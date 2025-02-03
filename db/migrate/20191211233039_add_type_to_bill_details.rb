class AddTypeToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :type, :string
  end
end
