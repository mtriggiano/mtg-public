class CreateReceivedBankChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :received_bank_checks do |t|
      t.string :serie
      t.string :numero, null: false
      t.date :fecha_emision, null: false
      t.date :fecha_pago, null: false
      t.decimal :monto, precision: 10, scale: 2, null: false
      t.string :cobrador
      t.string :numero_cuenta, null: false
      t.string :sucursal
      t.boolean :endosable, null: false, default: false
      t.boolean :cruzado, null: false, default: false
      t.string  :estado, null: false

      t.timestamps
    end
  end
end
