class CreateCheckPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :check_payments do |t|
      t.string :codigo_transaccion
      t.decimal :monto, precision: 10, scale: 2, null: false
      t.date :fecha, null: false
      t.references :emitted_bank_check, foreign_key: true
      t.references :bank_account, foreign_key: true

      t.timestamps
    end
  end
end
