class AddDefaultToReceivedBankCheck < ActiveRecord::Migration[5.2]
  def change
    change_column :received_bank_checks, :estado, :string, default: "Recibido"
  end
end
