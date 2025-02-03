class AddBranchToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :branch, :string
  end
end
