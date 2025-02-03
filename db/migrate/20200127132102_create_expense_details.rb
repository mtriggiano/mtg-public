class CreateExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_details do |t|
      t.references :cash_solicitude, foreign_key: true
      t.date :fecha, null: false
      t.string :letra, null: false
      t.string :punto_venta, null: false
      t.string :num_comprobante, null: false
      t.references :entity, foreign_key: true
      t.string :supplier_name, null: false
      t.string :descripcion, null: false
      t.decimal :total, null: false, precision: 10, scale: 2
      t.decimal :sum_iva, precision: 10, scale: 2
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
