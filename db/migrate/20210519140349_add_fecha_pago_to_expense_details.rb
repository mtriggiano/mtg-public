class AddFechaPagoToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :fecha_pago, :date
  end
end
