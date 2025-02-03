class AddSelectableToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :selectable, :boolean, default: true
  end
end
