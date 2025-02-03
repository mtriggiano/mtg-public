class AddReceiptNumberToDevolutions < ActiveRecord::Migration[5.2]
  def change
  	add_column :devolutions, :shipment_number, :string, default: nil
  end
end
