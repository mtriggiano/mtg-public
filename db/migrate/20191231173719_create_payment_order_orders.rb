class CreatePaymentOrderOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_order_orders do |t|
      t.references :order, foreign_key: true
      t.references :payment_order, foreign_key: true
      t.float :total, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
