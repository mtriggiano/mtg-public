class CreateAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :abilities do |t|
      t.string :action_name
      t.string :class_name
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
