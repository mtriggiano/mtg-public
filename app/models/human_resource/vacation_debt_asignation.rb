class VacationDebtAsignation < ApplicationRecord
  belongs_to :user_vacation, class_name: "UserVacation"
  belongs_to :debt_vacation, class_name: "UserDebtVacation", foreign_key: :user_debt_vacation_id

  #after_create :discount_vacation
  after_destroy :recount_vacation

  def discount_vacation
    debt_vacation.update_columns(days: (debt_vacation.days - self.days))
  end

  def recount_vacation
    debt_vacation.update_columns(days: (debt_vacation.days + self.days)) if user_vacation.approved?
  end
end
