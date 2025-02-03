class AddConsumptionDetailToBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :batches, :consumption_detail_id, :bigint
  end
end
