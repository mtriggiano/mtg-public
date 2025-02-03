class ChangeBalanceFromPaymentTypes < ActiveRecord::Migration[5.2]
  def change
  	change_column :payment_types, :balance, :float, null: false, default: 0 
  end
end
