class AttendanceCategoryUser < ApplicationRecord
  belongs_to :user
  belongs_to :attendance_category

  validates_uniqueness_of :user_id, scope: :attendance_category_id

end
