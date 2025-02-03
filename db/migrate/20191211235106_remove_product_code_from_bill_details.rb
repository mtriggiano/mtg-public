class RemoveProductCodeFromBillDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :bill_details, :product_code, :string
    add_column :bill_details, :product_code, :string
  end
end
