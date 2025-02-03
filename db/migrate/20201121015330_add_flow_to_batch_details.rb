class AddFlowToBatchDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :batch_details, :flow, :integer
  end
end
