class CreateEmittedBankChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :emitted_bank_checks do |t|
      t.references :checkbook, foreign_key: true, null: false
      t.string :numero, null: false
      t.date :fecha_emision, null: false
      t.date :fecha_pago
      t.decimal :monto, null: false, precision: 10, scale: 2
      t.string :cobrador
      t.boolean :endosable, null: false, default: false
      t.boolean :cruzado, null: false, default: false
      t.string :estado, null: false
      t.string :rechazo

      t.timestamps
    end
  end
end
