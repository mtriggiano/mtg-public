class CreateTributes < ActiveRecord::Migration[5.2]
  def change
    create_table :tributes do |t|
      t.references :bill, foreign_key: true
      t.string :afip_id, null: false
      t.float :base_imp, null: false, default: 0.0
      t.float :alic, null: false, default: 0.0
      t.float :amount, null: false, default: 0.0

      t.timestamps
    end
  end
end
