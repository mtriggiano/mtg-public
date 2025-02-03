class AddPaymentOrderToAccountMovements < ActiveRecord::Migration[5.2]
  def change
    add_reference :account_movements, :payment_order, foreign_key: true
  end
end
