class AddGrossAmountToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :gross_amount, :float, default: 0.0
  end
end
