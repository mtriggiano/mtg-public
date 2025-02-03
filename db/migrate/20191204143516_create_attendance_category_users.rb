class CreateAttendanceCategoryUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_category_users do |t|
      t.references :user, foreign_key: true
      t.references :attendance_category, foreign_key: true
    end
  end
end
