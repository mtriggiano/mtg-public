class CreateAttendanceCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :attendance_categories do |t|
      t.string :name
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday
      t.float :price_per_hour
      t.float :price_per_extra_hour
      t.float :early
      t.float :late
      t.time :check_in
      t.time :check_out
    end
  end
end
