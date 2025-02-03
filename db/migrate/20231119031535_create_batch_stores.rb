class CreateBatchStores < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_stores do |t|
      t.references :batch, foreign_key: true
      t.references :store, foreign_key: true
      t.float :quantity, default: 0.0, null: false

      t.timestamps
    end
  end
end
