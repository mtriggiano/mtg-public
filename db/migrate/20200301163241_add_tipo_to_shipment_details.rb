class AddTipoToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :tipo, :string
  end
end
