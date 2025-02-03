class CreateBillMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_movements do |t|
      t.references :bill, foreign_key: true
      t.date :date, null: false, default: ->{ "CURRENT_DATE" }
      t.string :bill_name, null: false
      t.string :client, null: false
      t.string :delivered_to
      t.boolean :signed, null: false, default: false
      t.boolean :returned, null: false, default: false
      t.text :observation

      t.timestamps
    end
  end
end
