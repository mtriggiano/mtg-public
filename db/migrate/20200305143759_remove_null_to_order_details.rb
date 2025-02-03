class RemoveNullToOrderDetails < ActiveRecord::Migration[5.2]
  def change
    change_column_null :order_details, :product_code, true
  end
end
