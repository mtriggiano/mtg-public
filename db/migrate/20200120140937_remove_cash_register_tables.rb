class RemoveCashRegisterTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :cash_register_data
  end
end
