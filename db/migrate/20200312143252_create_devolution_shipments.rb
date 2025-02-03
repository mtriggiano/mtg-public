class CreateDevolutionShipments < ActiveRecord::Migration[5.2]
  def change
    create_table :devolution_shipments do |t|
      t.references :devolution, foreign_key: true
      t.references :shipment, foreign_key: true
      t.string :type
      t.boolean :active
    end
  end
end
