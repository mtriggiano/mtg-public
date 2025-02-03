class AttendanceResume < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true
  has_many :attendances, dependent: :destroy

  validates_presence_of :user_id, message: "Debe ingresar un usuario."

  default_scope {where(active: true)}

  def destroy
    update_columns(active: false)
  end
end
