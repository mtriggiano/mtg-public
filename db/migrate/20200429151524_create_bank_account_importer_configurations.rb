class CreateBankAccountImporterConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_account_importer_configurations do |t|
      t.references :bank_account, foreign_key: true
      t.integer :fecha
      t.integer :descipcion
      t.integer :debito
      t.integer :credito
      t.integer :saldo

      t.timestamps
    end
  end
end
