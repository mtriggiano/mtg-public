class CreateCheckDeposits < ActiveRecord::Migration[5.2]
  def change
    create_table :check_deposits do |t|
      t.references :bank_account, foreign_key: true
      t.references :received_bank_check, foreign_key: true
      t.date :fecha, null: false
      t.boolean :cobrado, null: false, default: false
      t.string :codigo_transaccion

      t.timestamps
    end
  end
end
