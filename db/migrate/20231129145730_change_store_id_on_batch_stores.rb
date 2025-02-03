class ChangeStoreIdOnBatchStores < ActiveRecord::Migration[5.2]
  def change
    BatchStore.where(store_id: 1).update_all(store_id: 3)
  end
end
