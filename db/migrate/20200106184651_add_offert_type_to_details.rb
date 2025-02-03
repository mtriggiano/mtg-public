class AddOffertTypeToDetails < ActiveRecord::Migration[5.2]
  def change
  	add_column :request_details, 	:base_offer, :boolean, null: false, default: :false
  	add_column :budget_details, 	:base_offer, :boolean, null: false, default: :false
  	add_column :order_details, 		:base_offer, :boolean, null: false, default: :false
  end
end
