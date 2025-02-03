module AttendanceManager
  class ResumeGenerator
    def initialize(attendances=nil)
      @attendances ||= attendances
    end

    def perform
      @attendances ||= Attendance.joins(:user).includes(:user).where(attendance_resume_id: nil).order(:date)
      non_working_days = NonWorkingDay.all.includes(:users).includes(:non_working_day_details).includes(non_working_day_details: :user)
      unless @attendances.blank?
        @attendances.group_by{|a| "#{a.date.month}/#{a.date.year}"}.each do |month_year, atts_grouped|
          min_date = atts_grouped.first.date #01/01/2020
          max_date = atts_grouped.last.date #31/01/2020

          att_setting = AttendanceSetting.first
          if att_setting.nil?
            first_period = min_date.at_beginning_of_month #01/01/2020
            final_period = max_date.at_end_of_month #31/05/2020
          else
            if att_setting.resume_type == "Primer Día del Mes"
              first_period = min_date.at_beginning_of_month
              final_period = max_date.at_end_of_month
            else
              first_period = min_date - 1.month
              first_period = Date.new(first_period.year, first_period.month, att_setting.first_day_of_resume)
              final_period = first_period + 1.month
              final_period = Date.new(final_period.year, final_period.month, att_setting.last_day_of_resume)
            end
          end
          update_attendance_resume_data(atts_grouped, first_period, final_period, non_working_days)
          # loop do
          #   #atts = atts_grouped.where(date: first_period..final_period)
          #   # break if final_period >= max_date
          #   # final_period += 1.month
          #   # first_period += 1.month
          # end
        end
      end
    end

    private

    def update_attendance_resume_data atts, first_date, last_date, non_working_days
      atts.group_by {|a| a.user}.each do |user, user_atts|
        atts_resume = AttendanceResume.where(initial_date: first_date, final_date: last_date, user_id: user.id, company_id: user.company_id).first_or_create
        atts_method = attendance_count_method_new(user, non_working_days, atts_resume.initial_date, atts_resume.final_date)
        user_atts.each do |user_att|
          user_att.update_columns(attendance_resume_id: atts_resume.id)
        end
        worked_days = atts_method[1].to_f
        atts_resume.cumpliment = (worked_days * 100 / atts_method.last).to_f
        atts_resume.att_count = atts_method[1].to_f
        atts_resume.total_att_in_month = atts_method.last
        if atts_resume.cumpliment > 100
          atts_resume.cumpliment = 100
        end
        atts_resume.month = last_date.month
        atts_resume.year = last_date.year
        atts_resume.worked_hours = set_work_time(atts_resume)
        atts_resume.extra_hours = set_extra_hours(atts_resume, user, non_working_days)
        atts_resume.save
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
