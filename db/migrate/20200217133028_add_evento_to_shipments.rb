class AddEventoToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :id_evento, :integer
  end
end
