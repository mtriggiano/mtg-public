class CreateBatchDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_details do |t|
      t.references :batch, foreign_key: true
      t.references :detail, polymorphic: true
      t.float :quantity, null: false, default: 0
      t.timestamps
    end
  end
end
