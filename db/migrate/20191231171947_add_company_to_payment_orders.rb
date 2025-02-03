class AddCompanyToPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_orders, :company, foreign_key: true
  end
end
