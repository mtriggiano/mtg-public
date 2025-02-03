class CreateJustifications < ActiveRecord::Migration[5.2]
  def change
    create_table :justifications do |t|
      t.references :user, foreign_key: true
      t.bigint :creator_id
      t.bigint :approver_id
      t.date :init_date
      t.date :final_date
      t.integer :days
      t.boolean :approved
      t.boolean :active
      t.references :company, foreign_key: true
      t.string :reason
      t.string :type
    end
  end
end
