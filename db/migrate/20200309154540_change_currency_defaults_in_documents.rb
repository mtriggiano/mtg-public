class ChangeCurrencyDefaultsInDocuments < ActiveRecord::Migration[5.2]
  def up
    change_column :bills, :currency, :string, default: "ARS"
    change_column :orders, :currency, :string, default: "ARS"
    change_column :budgets, :currency, :string, default: "ARS"
    change_column :receipts, :currency, :string, default: "ARS"
    change_column :payment_orders, :currency, :string, default: "ARS"
    change_column :price_histories, :currency, :string, default: "ARS"
  end

  def down
    change_column :bills, :currency, :string, default: "PES"
    change_column :orders, :currency, :string, default: "PES"
    change_column :budgets, :currency, :string, default: "PES"
    change_column :receipts, :currency, :string, default: "PES"
    change_column :payment_orders, :currency, :string, default: "PES"
    change_column :price_histories, :currency, :string, default: "PES"
  end
end
