class AddGtinToDevolutionDetails < ActiveRecord::Migration[5.2]
  def change
    add_reference :devolution_details, :gtin, foreign_key: true
  end
end
