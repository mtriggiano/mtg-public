module AttendanceManager
  class AusentsChecker

    def initialize date
      @date = date
    end

    def perform
      users = User.where(active: true).includes(:attendances).includes(:attendance_categories).where(talliable: true, status: 'Activo')
      create_attendance_with_present_false users, @date
    end

  end
end


def create_attendance_with_present_false users, date
    non_working_days = NonWorkingDay.all.includes(:users)
    atts_not = []
    users.each do |user|
      atts = user.attendances.where("attendances.date = ?", date.to_date).where("attendances.justification_label IN (?) OR attendances.present = ?", ["Enfermedad", "Suspensión", "Permiso", "Presente", "En vacaciones", "Ausente por llegada tarde"], true)
      user_non_working_days = non_working_days.map{|a| a if a.users.where(id: user.id).blank?}.compact
      unless user.attendance_categories.blank?
        working_days = user.attendance_categories.map{|a| a.english_working_days}.reduce(:+).uniq
        #se traen todos los dias no laborales excepto donde el usuario esta excluido
        band = working_days.include?(Date::DAYNAMES[date.wday].capitalize) && !user_non_working_days.map{|nw| nw.date}.include?(date)
        if atts.blank?
          if band
            #si el usuario es tarjable, se debe agregar la asistencia al vector para las notificaciones
            new_att = user.attendances.where(date: date.to_date).first_or_initialize
            new_att.check_in = nil
            new_att.check_out = nil
            new_att.vacation = false
            new_att.present = false
            new_att.no_category_alert = true
            new_att.justified = false
            new_att.attendance_resume_id = nil
            new_att.present_label = "Ausente"
            new_att.justification_label = "Injustificado"
            new_att.save
            #atts_not << new_att
            atts_not << NonPresentUser.where(attendance_id: new_att.id, user_id: user.id, date: date).first_or_create
          end
        end
      else
        #no tiene turno por lo tanto debemos verificar si no tiene un "non_working_day" solamente
        band = !user_non_working_days.map{|nw| nw.date}.include?(date)
        if @atts.blank?
          if (band) && (date.wday != 0)
            new_att = user.attendances.where(date: date.to_date).first_or_initialize
            new_att.check_in = nil
            new_att.check_out = nil
            new_att.vacation = false
            new_att.present = false
            new_att.present_label = "Ausente"
            new_att.justification_label = "Injustificado"
            new_att.no_category_alert = true
            new_att.date = date.to_date
            new_att.justified = false
            new_att.attendance_resume_id = nil
            new_att.save
            #atts_not << new_att
            atts_not << NonPresentUser.where(attendance_id: new_att.id, user_id: user.id, date: date).first_or_create
          end
        end
      end
      AttendanceManager::ResumeGenerator.new.perform
      #atts_not = Attendance.where(date: date, present: false).where.not(justified: true, vacation: true, user_id: not_users_id)
      # unless atts_not.empty?
      #   #Notification.create_not_present_notifications atts_not, date
      # end
    end
  end
