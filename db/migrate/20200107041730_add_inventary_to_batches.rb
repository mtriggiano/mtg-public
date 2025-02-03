class AddInventaryToBatches < ActiveRecord::Migration[5.2]
  def change
    add_reference :batches, :product, foreign_key: true
  end
end
