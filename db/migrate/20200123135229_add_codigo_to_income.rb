class AddCodigoToIncome < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_account_logs, :codigo, :string
  end
end
