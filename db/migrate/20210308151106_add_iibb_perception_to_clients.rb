class AddIibbPerceptionToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :iibb_perception, :boolean
    add_column :entities, :iibb_aliquot, :decimal, precision: 10, scale: 2, default: "3.6"
  end
end
