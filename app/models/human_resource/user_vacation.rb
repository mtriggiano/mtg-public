class UserVacation < Justification
  has_many :days_asignations, class_name: "VacationDebtAsignation", dependent: :destroy
  after_save :discount_vacation, if: :approved?
  after_create :create_days_asignations
  after_save :set_justified_attendance, if: :approved?
  accepts_nested_attributes_for :days_asignations, allow_destroy: true, reject_if: :all_blank

  default_scope {where(type: 'UserVacation')}

  def discount_vacation
    days_asignations.each do |da|
      da.discount_vacation
    end
  end

  def create_days_asignations
    days_discount = self.days
    user.debt_vacations.where("user_debt_vacations.days > 0").order("user_debt_vacations.year ASC").each do |dv|
      days_to_assign = days_discount >= dv.days ? dv.days : days_discount
      self.days_asignations.create(user_debt_vacation_id: dv.id, days: days_to_assign)
      days_discount -= days_to_assign
      break if days_discount == 0
    end
  end


  def set_justified_attendance
    if approved && saved_change_to_approved? && attendances.blank?
      AttendanceManager::Justifier.new(user, 'vacation', init_date, days, self).vacation_justifier
      # user.set_status "En vacaciones", self.finaldate
      #UserManager::UserStateChanger.new(user.id, "En vacaciones", final_date, true, "estaba de vacaciones").delay(run_at: initialdate.to_datetime).perform_justification_state unless (final_date < Date.today)
    end
  end
end
