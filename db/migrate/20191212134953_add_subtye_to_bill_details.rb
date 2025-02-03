class AddSubtyeToBillDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :bill_details, :subtype, :string
  end
end
