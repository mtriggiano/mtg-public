class AddClientPaymentOrderToReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts, :client_payment_order, :string
  end
end
