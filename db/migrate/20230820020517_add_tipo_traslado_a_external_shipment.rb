class AddTipoTrasladoAExternalShipment < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :traslado_stock_interno, :boolean, default: false
    add_column :arrivals, :traslado_stock_interno, :boolean, default: false
  end
end
