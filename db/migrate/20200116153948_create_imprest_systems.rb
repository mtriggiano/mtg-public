class CreateImprestSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :imprest_systems do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true
      t.string :nombre_descriptivo, null: false
      t.decimal :fondo_fijo, precision: 10, scale: 2, null: false
      t.decimal :limite_max, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
