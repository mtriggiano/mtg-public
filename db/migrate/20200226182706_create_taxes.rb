class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
  	drop_table :expedient_receipt_taxes
    create_table :taxes do |t|
      t.string :tipo, null: false
      t.string :number
      t.float :total, default: 0, null: false
      t.references :taxable, polymorphic: true
      t.references :company

      t.timestamps
    end
  end
end
