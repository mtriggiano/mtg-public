class AddPaymentTypeToBills < ActiveRecord::Migration[5.2]
  def change
    add_reference :bills, :payment_type, foreign_key: true
  end
end
