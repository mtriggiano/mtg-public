class NonPresentUser < ApplicationRecord
  belongs_to :attendance
  belongs_to :user

  validates_uniqueness_of :attendance_id
end
