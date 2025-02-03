class CreateCashWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_withdrawals do |t|
      t.references :cash_solicitude, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :importe, precision: 10, scale: 2, null: false
      t.date :fecha, null: false

      t.timestamps
    end
  end
end
