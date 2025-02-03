class CreateCashAccountLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_account_logs do |t|
      t.references :cash_account, foreign_key: true
      t.datetime :date, null: false
      t.string :description, null: false
      t.boolean :flow, null: false
      t.decimal :monto, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
