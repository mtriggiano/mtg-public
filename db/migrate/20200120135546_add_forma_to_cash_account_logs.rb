class AddFormaToCashAccountLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_account_logs, :forma, :string
  end
end
