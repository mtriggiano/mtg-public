class AddStoreToDevolutions < ActiveRecord::Migration[5.2]
  def change
    add_reference :devolutions, :store, foreign_key: true
  end
end
