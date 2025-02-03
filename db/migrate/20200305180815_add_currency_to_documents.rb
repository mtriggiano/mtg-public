class AddCurrencyToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :currency, :string, default: "PES"
    add_column :budgets, :currency, :string, default: "PES"
    add_column :orders, :currency, :string, default: "PES"
    add_column :payment_orders, :currency, :string, default: "PES"
    add_column :receipts, :currency, :string, default: "PES"
  end
end
