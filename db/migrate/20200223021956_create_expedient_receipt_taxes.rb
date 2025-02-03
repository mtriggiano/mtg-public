class CreateExpedientReceiptTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :expedient_receipt_taxes do |t|
      t.references :receipt, foreign_key: true
      t.string :tax_type, null: false
      t.string :number
      t.string :total, null: false, default: 0

      t.timestamps
    end
  end
end
