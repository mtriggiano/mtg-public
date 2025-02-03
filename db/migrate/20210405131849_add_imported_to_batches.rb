class AddImportedToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :imported, :boolean, default: false
  end
end
