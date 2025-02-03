class AddDateToAccountMovements < ActiveRecord::Migration[5.2]
  def change
    add_column :account_movements, :date, :date
  end
end
