class AddAmountColumnTypeToBankAccountImporterConfigurations < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_account_importer_configurations, :amount_column_type_unique, :boolean, default: false
    add_column :bank_account_importer_configurations, :amount, :integer
  end
end
