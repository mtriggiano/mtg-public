class AddStateToBatchDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :batch_details, :state, :integer
  end
end
