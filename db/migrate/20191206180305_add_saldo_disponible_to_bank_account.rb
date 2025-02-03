class AddSaldoDisponibleToBankAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :saldo_disponible, :decimal, precision: 10, scale: 2, default: 0, null: false
  end
end
