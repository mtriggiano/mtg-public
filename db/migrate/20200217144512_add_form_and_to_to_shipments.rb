class AddFormAndToToShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :shipments, :from, :string
    add_column :shipments, :to, :string
  end
end
