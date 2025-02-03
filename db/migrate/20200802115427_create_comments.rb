class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :articleable, polymorphic: true
      t.references :user, foreign_key: true
      t.string :body, null: false, limit: 10000
      t.boolean :seen, null: false, default: false
      t.datetime :seen_at

      t.timestamps
    end
  end
end
