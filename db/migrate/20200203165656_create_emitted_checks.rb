class CreateEmittedChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :emitted_checks do |t|
      t.references :entity, foreign_key: true
      t.references :company, foreign_key: true
      t.references :payment_order, foreign_key: true
      t.string :concepto, null: false
      t.decimal :importe, null: false, precision: 10, scale: 2
      t.decimal :importe_pagado, defualt: 0, null: false, precision: 10, scale: 2
      t.decimal :saldo, null: false, precision: 10, scale: 2
      t.references :checkbook, foreign_key: true
      t.string :numero, null: false
      t.date :vencimiento, null: false

      t.timestamps
    end
  end
end
