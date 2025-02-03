class AddCompanyToAttendanceCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :attendance_categories, :company, foreign_key: true
  end
end
