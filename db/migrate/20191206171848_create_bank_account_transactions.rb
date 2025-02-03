class CreateBankAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_account_transactions do |t|
      t.datetime :fecha, null: false
      t.string :descripcion, null: false
      t.boolean :flow, null: false
      t.decimal :monto, null: false, precision: 10, scale: 2
      t.references :bank_account, foreign_key: true, null: false

      t.timestamps
    end
  end
end
