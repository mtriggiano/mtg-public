class AddObservacionToPaymentOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_orders, :observations, :text
  end
end
