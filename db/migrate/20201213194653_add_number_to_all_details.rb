class AddNumberToAllDetails < ActiveRecord::Migration[5.2]
  def change
  	add_column :request_details, :number, :integer
  	add_column :budget_details, :number, :integer
  	add_column :order_details, :number, :integer
  	add_column :shipment_details, :number, :integer
  	add_column :devolution_details, :number, :integer
  	add_column :bill_details, :number, :integer
  	add_column :arrival_details, :number, :integer
  end
end
