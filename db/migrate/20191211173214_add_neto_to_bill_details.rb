class AddNetoToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :neto, :decimal, null: false, default: 0.0, limit: 2
  end
end
