class CreateWorkStations < ActiveRecord::Migration[5.2]
  def change
    create_table :work_stations do |t|
      t.string :name
      t.text :description
      t.bigint :responsable_id
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
