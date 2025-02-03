class WorkStation < ApplicationRecord
  belongs_to :company
  belongs_to :responsable, class_name: "User", foreign_key: :responsable_id
  has_many :users
end
