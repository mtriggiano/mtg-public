class UserDebtVacation < ApplicationRecord
  belongs_to :user
  validates_presence_of :year, message: 'El año es necesario'
  validates_uniqueness_of:year, scope: :user_id, message: 'El año no puede repetirse'
  has_many :days_asignations, class_name: 'VacationDebtAsignation'

  def self.current_year user
    return user.debt_vacations.where(year: Date.today.year).first
  end

end
