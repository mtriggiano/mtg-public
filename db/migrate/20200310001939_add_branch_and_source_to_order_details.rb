class AddBranchAndSourceToOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :order_details, :branch, :string
    add_column :order_details, :source, :string
  end
end
