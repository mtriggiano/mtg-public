class AddFechaDepositoToPromissoryPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :promissory_payments, :fecha_deposito, :date
  end
end
