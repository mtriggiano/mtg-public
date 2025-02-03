class AddPriceToConsumptionDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :price, :float, default: 0.0
  end
end
