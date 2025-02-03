class AddTotalToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :total, :float, default: 0.0
  end
end
