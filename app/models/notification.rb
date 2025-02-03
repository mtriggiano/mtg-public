class Notification < ApplicationRecord
  belongs_to :company
  belongs_to :department, optional: true
  belongs_to :user, optional: true
  belongs_to :role, optional: true

  scope :unseen, ->{ where(seen: false)}
end
