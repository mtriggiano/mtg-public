class CreateDevolutionArrivals < ActiveRecord::Migration[5.2]
  def change
    create_table :devolution_arrivals do |t|
      t.references :devolution, foreign_key: true
      t.references :arrival, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
