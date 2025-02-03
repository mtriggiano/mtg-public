class ChangeDefaultStateToGtins < ActiveRecord::Migration[5.2]
  def change
  	change_column :gtins, :state, :boolean, null: false, default: false
  end
end
