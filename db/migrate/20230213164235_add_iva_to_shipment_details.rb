class AddIvaToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
  	add_column :shipment_details, :iva_aliquot, :string, default: "05"  	
  end
end
