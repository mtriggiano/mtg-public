class CreatePaymentOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_orders do |t|
      t.references :entity, foreign_key: true
      t.references :order_payment_day, foreign_key: true
      t.string :state, null: false, default: "Pendiente"
      t.references :user, foreign_key: true
      t.boolean :active, null: false, default: true
      t.date :date, null: false
      t.float :total, null: false
      t.string :number, null: false

      t.timestamps
    end
  end
end
