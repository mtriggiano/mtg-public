class CreateDailyCashBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_cash_balances do |t|
      t.references :cash_account, foreign_key: true
      t.boolean :apertura, null: false
      t.decimal :importe, precision: 10, scale: 2, null: false
      t.date :fecha, null: false
      t.references :user, foreign_key: true
      t.string :type
      t.decimal :balance, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
