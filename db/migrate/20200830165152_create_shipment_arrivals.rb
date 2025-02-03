class CreateShipmentArrivals < ActiveRecord::Migration[5.2]
  def change
    create_table :shipment_arrivals do |t|
      t.references :shipment, foreign_key: true
      t.references :arrival, foreign_key: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
