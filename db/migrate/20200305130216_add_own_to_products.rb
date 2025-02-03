class AddOwnToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :own, :boolean, null: false, default: true
  end
end
