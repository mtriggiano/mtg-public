class RemoveNullFalseFromArrivalDetails < ActiveRecord::Migration[5.2]
  def up
  	remove_column :arrival_details, :product_code, :string
  	add_column :arrival_details, :product_code, :string
  end

  def down
  	
  end
end
