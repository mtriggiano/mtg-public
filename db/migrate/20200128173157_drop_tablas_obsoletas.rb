class DropTablasObsoletas < ActiveRecord::Migration[5.2]
  def change
    drop_table :check_collects
    drop_table :check_deposits
    drop_table :check_payments
    drop_table :emitted_bank_checks
    drop_table :received_bank_checks
  end
end
