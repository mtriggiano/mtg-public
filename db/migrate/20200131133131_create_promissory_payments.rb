class CreatePromissoryPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :promissory_payments do |t|
      t.references :entity, foreign_key: true
      t.references :company, foreign_key: true
      t.references :receipt, foreign_key: true
      t.string :concepto, null: false
      t.decimal :importe, precision: 10, scale: 2, null: false
      t.decimal :importe_cobrado, precision: 10, scale: 2
      t.string :numero_cheque
      t.date :vencimiento, null: false
      t.string :type

      t.timestamps
    end
  end
end
