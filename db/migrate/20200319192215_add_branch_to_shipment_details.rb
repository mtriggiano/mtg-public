class AddBranchToShipmentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :shipment_details, :branch, :string
  end
end
