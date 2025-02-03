class AddTipoDePagoAExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :tipo_pago, :string, null: true, default: nil
  end
end
