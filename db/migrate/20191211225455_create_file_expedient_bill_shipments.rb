class CreateFileExpedientBillShipments < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_shipments do |t|
      t.references :bill, foreign_key: true
      t.references :shipment, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
