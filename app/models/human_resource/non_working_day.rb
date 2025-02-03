class NonWorkingDay < ApplicationRecord
  belongs_to :company
  has_many :non_working_day_details, dependent: :destroy
  has_many :users, through: :non_working_day_details
  accepts_nested_attributes_for :non_working_day_details, allow_destroy: true, reject_if: :all_blank

  HOLIDAY_TYPES = ["Feriado", "Día no laboral"]

  validates_presence_of :reason, message: "Debe ingresar el motivo del feriado."
  validates :date,
    presence: { message: "Debe seleccionar la fecha del feriado" },
    uniqueness: { message: "Ya existe un feriado registrado para la fecha seleccionada." }
  validates :holiday_type,
    presence: { message: "Debe seleccionar el tipo de feriado." },
    inclusion: { in: HOLIDAY_TYPES }
  #validate :check_date

  def check_date
    if !date.blank? && date <= (Date.today)
      errors.add(:non_working_day, "La fecha seleccionada debe ser posterior al día de hoy.")
    end
  end

  def start_time
    self.init_date
  end

  def init_date
    read_attribute(:date) || Date.today
  end

  def final_date
    read_attribute(:date) || Date.today
  end
end
