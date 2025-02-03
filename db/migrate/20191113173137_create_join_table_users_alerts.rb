class CreateJoinTableUsersAlerts < ActiveRecord::Migration[5.2]
  def change
  	drop_table :user_alerts
    create_join_table :users, :alerts do |t|
      t.index [:user_id, :alert_id]
      t.index [:alert_id, :user_id]
    end
  end
end
