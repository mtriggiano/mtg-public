class CreateCashRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_refunds do |t|
      t.references :cash_solicitude, foreign_key: true
      t.references :user, foreign_key: true
      t.date :fecha, null: false
      t.decimal :importe, null: false, precision: 10, scale: 2
      t.text :observacion

      t.timestamps
    end
  end
end
