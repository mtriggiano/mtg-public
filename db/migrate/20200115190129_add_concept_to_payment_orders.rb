class AddConceptToPaymentOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_orders, :concept, :text
  end
end
