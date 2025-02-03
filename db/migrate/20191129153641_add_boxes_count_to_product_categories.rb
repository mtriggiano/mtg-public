class AddBoxesCountToProductCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :product_categories, :boxes_count, :integer, null: false, default: 0
  end
end
