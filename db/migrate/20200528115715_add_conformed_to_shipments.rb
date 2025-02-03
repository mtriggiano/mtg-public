class AddConformedToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :conformed, :boolean, null: false, default: false
    add_column :shipments, :conformed_file, :string
    add_column :shipments, :conformed_at, :datetime
    add_column :shipments, :conformed_by, :bigint
  end
end
