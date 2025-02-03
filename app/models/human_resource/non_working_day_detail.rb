class NonWorkingDayDetail < ApplicationRecord
  belongs_to :user
  belongs_to :non_working_day

  validates :user_id, uniqueness: {scope: :non_working_day_id, message: "El usuario ya está excluído del día no laboral"}
end
