class CreateBillOptionals < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_optionals do |t|
      t.references :bill, foreign_key: true
      t.integer :afip_id
      t.string :valor

      t.timestamps
    end
  end
end
