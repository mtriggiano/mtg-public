class SetDefaultStoreToBatchDetails < ActiveRecord::Migration[5.2]
  def up
    BatchDetail.preload(:detail).each do |batch_detail|
      batch_detail.update_columns(store_id: batch_detail.get_store.try(:id))
    end
  end
  def down
    
  end
end
