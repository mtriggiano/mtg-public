class AddFixToOrderPaymentDays < ActiveRecord::Migration[5.2]
  def change
  	remove_column :order_payment_days, :date, :date
  	remove_column :order_payment_days, :paid, :boolean
    add_reference :order_payment_days, :payment_type, foreign_key: true
    add_column :order_payment_days, :observation, :string
  end
end
