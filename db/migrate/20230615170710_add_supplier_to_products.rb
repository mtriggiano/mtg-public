class AddSupplierToProducts < ActiveRecord::Migration[5.2]
  def change
  	add_reference :products, :supplier
  	remove_column :products, :supplier
  end
end
