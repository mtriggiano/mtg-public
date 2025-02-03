class CreateCostSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :cost_sub_categories do |t|
      t.string :nombre, null: false
      t.references :cost_category, foreign_key: true

      t.timestamps
    end
  end
end
