class AddSellerToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :seller_id, :bigint
  end
end
