class CreateCashAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_accounts do |t|
      t.string :nombre, null: false
      t.decimal :saldo, precision: 10, scale: 2, null: false, default: 0
      t.string :type, null: false
      t.references :user, foreign_key: true, index: true
      t.references :company, foreign_key: true, index: true

      t.timestamps
    end
  end
end
