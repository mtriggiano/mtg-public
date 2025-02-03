class CreatePriceUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :price_updates do |t|
      t.decimal :percent
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :log

      t.timestamps
    end
  end
end
