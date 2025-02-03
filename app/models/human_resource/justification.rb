class Justification < ApplicationRecord
  self.table_name = :justifications
  include HasAttachments

  belongs_to :user
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :approver, class_name: "User", foreign_key: :approver_id, optional: true
  belongs_to :company



  has_many :assoc_attendances, as: :justificable, class_name: 'Attendance'

  validates_presence_of :days, message: 'Debe indicar los días justificados'

  validate :check_dates, on: :save

  before_validation :check_final_date

  #before_destroy :unset_attendances


  REASONS = ["Enfermedad", "Suspensión", "Permiso"]

  def check_final_date
    self.final_date = self.init_date + (self.days - 1).days
  end

  def check_days
    # code
  end

  def attendances
    Attendance.where(user_id: self.user_id, justificable_id: self.id, justificable_type: self.class.name)
  end

  def unset_attendances
    resumes = attendances.map(&:attendance_resume_id)
    attendances.destroy_all
    AttendanceManager::ResumeUpdater.new(resumes).perform
  end


  def disabled?
    not editable? || new_record?
  end

  def editable?
    !approved || errors.any?
  end

  def check_dates
    if saved_change_to_init_date? || saved_change_to_final_date?
      if final_date < initial_date
        errors.add("Fechas", 'La fecha final no puede ser menor a la fecha inicial')
      end
    end
  end





end
