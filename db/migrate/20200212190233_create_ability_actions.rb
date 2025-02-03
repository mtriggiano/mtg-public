class CreateAbilityActions < ActiveRecord::Migration[5.2]
  def change
    remove_column :abilities, :action_name, :string
    create_table :ability_actions do |t|
      t.string :name
      t.references :ability, foreign_key: true

      t.timestamps
    end
  end
end
