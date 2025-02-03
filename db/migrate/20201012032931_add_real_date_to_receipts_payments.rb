class AddRealDateToReceiptsPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts_payments, :real_date, :date
  end
end
