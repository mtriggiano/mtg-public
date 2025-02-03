module AttendanceManager
  class ResumeUpdater

    def initialize(resume_ids)
      @resume_ids = resume_ids
    end

    def perform
      update_resumes_data(@resume_ids)
    end


    private

    def update_resumes_data resume_ids
      resumes = AttendanceResume.where(id: resume_ids)
      non_working_days = NonWorkingDay.all.includes(:users).includes(:non_working_day_details).includes(non_working_day_details: :user)
      resumes.each do |atts_resume|
        atts_resume.attendances.joins(:user).includes(:user).order(:date).group_by {|a| a.user}.each do |user, user_atts|
          usuario = user
          atts_method = attendance_count_method_new(usuario, non_working_days, atts_resume.initial_date, atts_resume.final_date)
          worked_days = atts_method[1].to_f
          atts_resume.cumpliment = (worked_days * 100 / atts_method.last).to_f
          atts_resume.att_count = atts_method[1].to_f
          atts_resume.total_att_in_month = atts_method.last
          if atts_resume.cumpliment > 100
            atts_resume.cumpliment = 100
          end
          atts_resume.worked_hours = set_work_time(atts_resume)
          atts_resume.extra_hours = set_extra_hours(atts_resume, usuario, non_working_days)
          atts_resume.save
        end
      end
    end
    def set_extra_hours atts_resume, usuario, non_working_days
      hours_debt = usuario.expected_monthly_hours(atts_resume.initial_date, atts_resume.final_date, non_working_days).to_f
      exhs = (atts_resume.worked_hours - hours_debt).to_f
      exhs = (exhs % 1 < 0.5) ? exhs.round(0) : exhs.round(1)
      extra_hours = exhs > 0 ? exhs : 0
      return extra_hours
    end

    def set_work_time atts_resume
      #PREGUNTAR SI CUENTA HORAS DE USUARIOS QUE LLEGARON TARDE
      wt = atts_resume.attendances.where(present: true).map{|a| a.work_time if !a.work_time.blank?}.compact.reduce(:+).to_f
      #wt = (wt % 1 < 0.5) ? wt.round(0) : wt.round(1)
      return wt
    end

    def attendance_count_method_new user, non_working_days, first_date, final_date
      att_categories = user.attendance_categories
      # para salvar errores de variables vacías simplemente nos muestra que el usuario
      # no posee un turno asociado
      if !att_categories.blank? && !non_working_days.nil?
        working_days = att_categories.map {|a| a.english_working_days}.reduce(:+).uniq
        attendances = user.attendances.where(date: first_date..final_date).where("attendances.present = 't' or attendances.justified = 't'")
        count = attendances.group_by {|a| a.date}.count
        attendance_count = 0
        user_non_working_days = non_working_days.map {|a| a if a.users.where(id: user.id).blank?}.compact
        (first_date.to_date..final_date.to_date).each do |day_of_resume|
          if working_days.include?(Date::DAYNAMES[day_of_resume.wday].capitalize) && !user_non_working_days.map {|nw| nw.date}.include?(day_of_resume)
            attendance_count += 1
          end
        end
        if count > attendance_count
          count = attendance_count
        end
        return "#{count.to_f} de #{attendance_count.to_f}", count.to_f, attendance_count
      elsif att_categories.blank? && !non_working_days.nil?
        # Si no tiene turnos asociados, contamos TODOS los dias del año como dias laborales excepto domingos y feriados para el tipo
        attendances = user.attendances.where(date: first_date..final_date).where("attendances.present = 't' or attendances.justified = 't'")
        count = attendances.group_by {|a| a.date}.count
        attendance_count = 0
        user_non_working_days = non_working_days.map {|a| a if a.users.where(id: user.id).blank?}.compact
        (first_date..final_date).each do |day_of_resume|
          if !(day_of_resume.wday == 0) && !user_non_working_days.map {|nw| nw.date}.include?(day_of_resume)
            attendance_count += 1
          end
        end
        if count > attendance_count
          count = attendance_count
        end
        return "#{count.to_f} de #{attendance_count.to_f}", count.to_f, attendance_count
      end
    end
  end
end
