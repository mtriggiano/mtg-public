class AddTypeToReturnsArrivals < ActiveRecord::Migration[5.2]
  def change
    add_column :returns_arrivals, :type, :string
  end
end
