class CreateAttendanceSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_settings do |t|
      t.string :resume_type
      t.integer :first_day_of_resume
      t.integer :last_day_of_resume

      t.timestamps
    end
  end
end
