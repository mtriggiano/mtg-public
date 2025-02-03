class AddGtinToArrivalDetails < ActiveRecord::Migration[5.2]
  def change
    add_reference :arrival_details, :gtin, foreign_key: true
  end
end
