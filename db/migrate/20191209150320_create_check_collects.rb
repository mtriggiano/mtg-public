class CreateCheckCollects < ActiveRecord::Migration[5.2]
  def change
    create_table :check_collects do |t|
      t.references :received_bank_check, foreign_key: true
      t.references :bank_account, foreign_key: true
      t.references :check_deposit, foreign_key: true
      t.string :codigo_transaccion
      t.decimal :monto, precision: 10, scale: 2, null: false
      t.date :fecha, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
