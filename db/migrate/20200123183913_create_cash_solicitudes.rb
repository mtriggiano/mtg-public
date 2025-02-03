class CreateCashSolicitudes < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_solicitudes do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :motivo, null: false
      t.date :fecha, null: false
      t.boolean :active, default: true, null: false
      t.boolean :evaluacion
      t.references :evaluador, foreign_key: { to_table: 'users' }
      t.string :rechazo
      t.boolean :fecha_eval
      t.decimal :monto_aprobado, precision: 10, scale: 2

      t.timestamps
    end
  end
end
