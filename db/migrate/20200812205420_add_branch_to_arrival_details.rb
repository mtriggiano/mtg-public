class AddBranchToArrivalDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :arrival_details, :branch, :string
  end
end
