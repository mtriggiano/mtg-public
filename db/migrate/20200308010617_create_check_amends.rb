class CreateCheckAmends < ActiveRecord::Migration[5.2]
  def change
    create_table :check_amends do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
