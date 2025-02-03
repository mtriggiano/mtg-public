class RemoveGtinFromArrivals < ActiveRecord::Migration[5.2]
  def change
    remove_reference :arrival_details, :gtin, foreign_key: true
    remove_reference :shipment_details, :gtin, foreign_key: true
    remove_reference :devolution_details, :gtin, foreign_key: true
  end
end
