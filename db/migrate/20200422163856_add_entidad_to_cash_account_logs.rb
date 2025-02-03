class AddEntidadToCashAccountLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_account_logs, :entidad, :string
  end
end
