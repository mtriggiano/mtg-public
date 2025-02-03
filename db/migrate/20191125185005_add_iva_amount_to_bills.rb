class AddIvaAmountToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :iva_amount, :float, default: 0.0
  end
end
