class AddSubtypeToEntity < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :subtype, :string
  end
end
