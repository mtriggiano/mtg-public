class AddCuentaMonedasToDailyCashBalance < ActiveRecord::Migration[5.2]
  def change
    add_column :daily_cash_balances, :cuenta_monedas, :json
  end
end
