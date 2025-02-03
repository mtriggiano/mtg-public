class CreateExpenditures < ActiveRecord::Migration[5.2]
  def change
    create_table :expenditures do |t|
      t.references :entity, foreign_key: true
      t.references :company, foreign_key: true
      t.string :supplier_name, null: false
      t.string :tipo, null: false
      t.string :punto_venta
      t.string :numero
      t.string :descripcion, null: false
      t.decimal :importe_bruto, precision: 10, scale: 2, null: false
      t.decimal :importe_neto, precision: 10, scale: 2, null: false
      t.decimal :iva, precision: 10, scale: 2, null: false
      t.decimal :iibb, precision: 10, scale: 2, null: false
      t.decimal :no_gravado, precision: 10, scale: 2, null: false
      t.date :fecha, null: false

      t.timestamps
    end
  end
end
