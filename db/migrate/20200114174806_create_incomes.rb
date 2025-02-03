class CreateIncomes < ActiveRecord::Migration[5.2]
  def change
    create_table :incomes do |t|
      t.string :codigo
      t.string :descripcion, null: false
      t.decimal :importe, null: false, precision: 10, scale: 2
      t.date :fecha, null: false
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :lugar
      t.string :type

      t.timestamps
    end
  end
end
