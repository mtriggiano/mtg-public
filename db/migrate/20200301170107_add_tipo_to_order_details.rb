class AddTipoToOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :order_details, :tipo, :string
  end
end
