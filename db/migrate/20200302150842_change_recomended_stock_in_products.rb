class ChangeRecomendedStockInProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :recommended_stock
    add_column :products, :recommended_stock, :float, default: 0.0, null: false
  end
end
