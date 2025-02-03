class CreateCostCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :cost_categories do |t|
      t.string :nombre, null: false

      t.timestamps
    end
  end
end
