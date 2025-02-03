class AddBillDueNotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bill_due_notification, :boolean, default: false
  end
end
