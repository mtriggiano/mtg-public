class CreateReceiptsPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts_payments do |t|
      t.references :receipt, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, null: false
      t.string :number
      t.date :due_date
      t.references :payment_type, foreign_key: true

      t.timestamps
    end
  end
end
