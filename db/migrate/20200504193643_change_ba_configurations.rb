class ChangeBaConfigurations < ActiveRecord::Migration[5.2]
  def change
    remove_column :bank_account_importer_configurations, :descipcion
    add_column :bank_account_importer_configurations, :descripcion, :integer
  end
end
