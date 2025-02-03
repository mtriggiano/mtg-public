class AddTransactionToGtins < ActiveRecord::Migration[5.2]
  def change
    add_column :gtins, :transaction_id, :integer
    add_column :gtins, :serial, :string
  end
end
