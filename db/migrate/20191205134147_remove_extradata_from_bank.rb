class RemoveExtradataFromBank < ActiveRecord::Migration[5.2]
  def change
    remove_column :banks, :account_number, :string
    remove_column :banks, :current_amount, :string
    remove_column :banks, :cbu, :string
  end
end
