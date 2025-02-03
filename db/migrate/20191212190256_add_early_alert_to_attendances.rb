class AddEarlyAlertToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :early_alert, :boolean, default: false
  end
end
