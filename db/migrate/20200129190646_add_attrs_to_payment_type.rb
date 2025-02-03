class AddAttrsToPaymentType < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_types, :cash_account, foreign_key: true
    add_column :payment_types, :collect_type, :string
  end
end
