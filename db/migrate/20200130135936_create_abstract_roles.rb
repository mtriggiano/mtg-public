class CreateAbstractRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :abstract_roles do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
