class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.references :shipment, foreign_key: true
      t.string :map
      t.string :address
      t.string :contact
      t.string :phone
      t.string :observation

      t.timestamps
    end
  end
end
