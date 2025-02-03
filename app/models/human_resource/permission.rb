class Permission < Justification
  after_save :set_justified_attendance, if: :approved?

  default_scope {where(type: 'Permission')}

  def set_justified_attendance
    if approved && saved_change_to_approved? && attendances.blank?
      AttendanceManager::Justifier.new(user, 'justification', init_date, days, self).perform
    end
  end



end
