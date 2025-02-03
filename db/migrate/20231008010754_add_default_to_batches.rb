class AddDefaultToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :default, :boolean, default: false
  end
end
