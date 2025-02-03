class AddSellerToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets, :seller_id, :bigint, foreign_key: true
  end
end
