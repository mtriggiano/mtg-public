class DropDeprecatedTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :cash_extension_returns
    drop_table :cash_requests
  end
end
