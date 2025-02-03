class CreateCashRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_requests do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.date :fecha
      t.string :motivo
      t.string :codigo
      t.boolean :listo, default: false, null: false

      t.timestamps
    end
  end
end
