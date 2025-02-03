class CreatePurchasesPaymentOrderPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_order_payments do |t|
      t.references :payment_order, foreign_key: true
      t.references :payment_type, foreign_key: true
      t.references :checkbook, foreign_key: true
      t.date :due_date
      t.string :number
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
