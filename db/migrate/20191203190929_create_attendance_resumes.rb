class CreateAttendanceResumes < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_resumes do |t|
      t.integer :month
      t.integer :year
      t.decimal :cumpliment
      t.references :user
      t.float :worked_hours, default: 0.0
      t.float :extra_hours, default: 0.0
      t.date :initial_date
      t.date :final_date
      t.float :att_count, default: 0.0
      t.float :total_att_in_month, default: 0.0
      t.boolean :active, default: true
      t.string :label_date
    end
  end
end
