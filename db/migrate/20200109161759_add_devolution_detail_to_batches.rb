class AddDevolutionDetailToBatches < ActiveRecord::Migration[5.2]
  def change
    add_reference :batches, :devolution_detail, foreign_key: true
  end
end
