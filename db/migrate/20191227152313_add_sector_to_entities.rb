class AddSectorToEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :sector, :string
  end
end
