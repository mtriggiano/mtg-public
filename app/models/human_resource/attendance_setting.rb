class AttendanceSetting < ApplicationRecord

  RESUME_TYPES = ["Primer Día del Mes", "Período personalizado"]

  validates_presence_of :first_day_of_resume, if: :custom_resume?
  validates_presence_of :last_day_of_resume, if: :custom_resume?
  validate :first_and_final_date, on: :save

  def first_and_final_date
    if resume_type == "Período personalizado"
      errors.add(:dates, "La fecha inicial no puede ser mayor a la fecha final") unless first_day_of_resume < last_day_of_resume
    end
  end

  def custom_resume?
    resume_type == "Período personalizado"
  end
end
