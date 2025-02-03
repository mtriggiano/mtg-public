class AddDelegationToEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :parent_id, :bigint, foreign_key: true
  end
end
