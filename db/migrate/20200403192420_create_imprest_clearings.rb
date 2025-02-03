class CreateImprestClearings < ActiveRecord::Migration[5.2]
  def change
    create_table :imprest_clearings do |t|
      t.bigint :general_cash_account_id, foreign_key: true, index: true
      t.bigint :regular_cash_account_id, foreign_key: true, index: true
      t.references :user, foreign_key: true
      t.datetime :fecha, null: false
      t.decimal :fondo_fijo, precision: 10, scale: 2, default: 0, null: false
      t.decimal :saldo_inicio, precision: 10, scale: 2, default: 0, null: false
      t.text :observaciones
      t.decimal :a_rendir, precision: 10, scale: 2, default: 0, null: false
      t.decimal :saldo_en_caja, precision: 10, scale: 2, default: 0, null: false
      t.datetime :tiempo_de_confirmacion

      t.timestamps
    end
  end
end
