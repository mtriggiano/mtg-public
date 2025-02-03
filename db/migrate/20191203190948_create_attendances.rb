class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :user, foreign_key: true
      t.references :attendance_resume, foreign_key: true
      t.date :date, null: false
      t.boolean :present, default: false
      t.boolean :vacation, default: false
      t.boolean :justified, default: false
      t.datetime :check_in
      t.datetime :check_out
      t.float :work_time
      t.boolean :late_alert, default: false
      t.boolean :no_category_alert, default: false
      t.float :minutes_late, default: 0.0
      t.string :present_label
      t.string :justification_label
      t.boolean :active, default: true
      t.references :justificable, polymorphic: true
    end
  end
end
