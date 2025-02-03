class CreateGeneralCashExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :general_cash_expenses do |t|
      t.string :codigo
      t.string :descripcion, null: false
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.decimal :importe, precision: 10, scale: 2, null: false
      t.string :lugar
      t.date :fecha, null: false
      t.string :type

      t.timestamps
    end
  end
end
