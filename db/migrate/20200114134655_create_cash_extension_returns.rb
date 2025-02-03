class CreateCashExtensionReturns < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_extension_returns do |t|
      t.references :expense, foreign_key: true
      t.string :importe
      t.date :fecha

      t.timestamps
    end
  end
end
