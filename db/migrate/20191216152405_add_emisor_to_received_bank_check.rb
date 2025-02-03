class AddEmisorToReceivedBankCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :received_bank_checks, :emisor, :string
  end
end
