class AddNumeroReciboToExpenseDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :numero_de_recibo, :integer
  end
end
