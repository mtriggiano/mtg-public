class CreateShipmentRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :shipment_requests do |t|
      t.references :shipment, foreign_key: true
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
