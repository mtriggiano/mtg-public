class AddPrimaryKeyToDevolutionsArrivals < ActiveRecord::Migration[5.2]
  def change
    add_column :devolutions_arrivals, :id, :primary_key
  end
end
