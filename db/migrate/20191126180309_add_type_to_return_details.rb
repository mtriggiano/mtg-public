class AddTypeToReturnDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :return_details, :type, :string
  end
end
