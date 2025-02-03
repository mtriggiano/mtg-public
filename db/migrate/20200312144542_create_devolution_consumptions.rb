class CreateDevolutionConsumptions < ActiveRecord::Migration[5.2]
  def change
    create_table :devolution_consumptions do |t|
      t.references :devolution, foreign_key: true
      t.bigint :consumption_id
      t.string :type
      t.boolean :active
    end
  end
end
