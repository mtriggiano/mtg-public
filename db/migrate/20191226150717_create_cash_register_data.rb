class CreateCashRegisterData < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_register_data do |t|
      t.references :cash_account, foreign_key: true
      t.decimal :limite_minimo, precision: 10, scale: 2, null: false, default: 0
      t.decimal :limite_maximo, precision: 10, scale: 2, null: false
      t.decimal :fondo_fijo, precision: 10, scale: 2
      t.boolean :estado, null: false, default: false
      t.boolean :habilitado, null: false, default: true
    end
  end
end
