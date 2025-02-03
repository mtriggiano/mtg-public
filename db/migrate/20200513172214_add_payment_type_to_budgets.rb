class AddPaymentTypeToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :payment_type, :string
  end
end
