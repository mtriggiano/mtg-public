class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title, limit: 100, null: false
      t.text :body, limit: 100000, null: false
      t.integer :priority, null: false, default: 1
      t.integer :function_points, null: false, default: 1
      t.date :init_date
      t.date :finish_date
      t.string :attachment
      t.string :state, null: false, default: 'pending'
      t.bigint :state_changed_by
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
