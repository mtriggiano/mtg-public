class AddTransactionToArrivalDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :arrival_details, :transaction_id, :integer
  end
end
