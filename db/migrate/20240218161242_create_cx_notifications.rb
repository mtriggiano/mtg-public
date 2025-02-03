class CreateCxNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :cx_notifications do |t|
      t.string :tipo

      t.timestamps
    end
  end
end
