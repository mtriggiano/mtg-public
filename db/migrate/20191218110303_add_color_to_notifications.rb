class AddColorToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :color, :string
  end
end
