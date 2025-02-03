class ChangeDefaultImporteToPromissoryPayments < ActiveRecord::Migration[5.2]
  def change
    change_column :promissory_payments, :importe, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
