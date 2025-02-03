class AddCustomAttributesToArrivalDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :arrival_details, :custom_attributes, :hstore
  end
end
