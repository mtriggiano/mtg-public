class AddStoreToBatchDetail < ActiveRecord::Migration[5.2]
  def change
    add_reference :batch_details, :store, foreign_key: true
  end
end
