class AddManualToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :manual, :string, null: false, default: "E"
  end
end
