class ChangeDatetimeAttrOnCashAccountLogs < ActiveRecord::Migration[5.2]
  def change
    change_column :cash_account_logs, :date, :date, null: false
  end
end
