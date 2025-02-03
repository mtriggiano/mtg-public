class SetDefaultToRecommendedStockInProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :recommended_stock, :float, default: 0.0
  end
end
