class AddBalanceToPaymentType < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_types, :balance, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
