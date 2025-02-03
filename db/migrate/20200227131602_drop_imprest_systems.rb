class DropImprestSystems < ActiveRecord::Migration[5.2]
  def change
    drop_table :imprest_systems
  end
end
