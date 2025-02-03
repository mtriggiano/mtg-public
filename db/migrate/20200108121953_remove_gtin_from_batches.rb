class RemoveGtinFromBatches < ActiveRecord::Migration[5.2]
  def change
    remove_reference :batches, :gtin, foreign_key: true
  end
end
