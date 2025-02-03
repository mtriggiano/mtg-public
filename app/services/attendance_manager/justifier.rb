module AttendanceManager
  class Justifier

    def initialize(user, type_of_justification, date, days_quantity, object)
      @user = user
      @type_of_justification = type_of_justification
      @date = date
      @days_quantity = days_quantity
      @object = object
    end

    def perform
      create_justified_attendances
      AttendanceManager::ResumeGenerator.new.perform
    end

    def vacation_justifier
      create_vacation_justification
      AttendanceManager::ResumeGenerator.new.perform
    end

    private

    def create_vacation_justification
      usuario = @user
      non_working_days = NonWorkingDay.all.includes(:users).includes(:non_working_day_details).includes(non_working_day_details: :user)
      user_non_working_days = non_working_days.map {|a| a if a.users.where(id: usuario.id).blank?}.compact
      att_categories = usuario.attendance_categories

      (@object.init_date .. @object.final_date).each do |date|
        unless att_categories.blank?
          working_days = att_categories.map {|a| a.english_working_days}.reduce(:+).uniq.compact
          if working_days.include?(Date::DAYNAMES[date.wday]) && !user_non_working_days.map {|nw| nw.date}.include?(date)
            if date.wday != 0
              attendance = vacation_justify(date)
              attendance_saver(attendance)
            end
          else
            if date.wday != 0 && !user_non_working_days.map {|nw| nw.date}.include?(date)
              attendance = vacation_justify(date)
              attendance_saver(attendance)
            end
          end
        else
          if date.wday != 0 && !user_non_working_days.map {|nw| nw.date}.include?(date)
            attendance = vacation_justify(date)
            attendance_saver(attendance)
          end
        end
      end
    end

    def create_justified_attendances
      usuario = @user
      non_working_days = NonWorkingDay.all.includes(:users).includes(:non_working_day_details).includes(non_working_day_details: :user)
      user_non_working_days = non_working_days.map {|a| a if a.users.where(id: usuario.id).blank?}.compact
      att_categories = usuario.attendance_categories

      if !att_categories.blank?
        working_days = att_categories.map {|a| a.english_working_days}.reduce(:+).uniq.compact
        i = 0
        newdate = @date.to_date
        while i < @days_quantity
          if working_days.include?(Date::DAYNAMES[newdate.wday]) && !user_non_working_days.map {|nw| nw.date}.include?(newdate)
            if newdate.wday != 0
              attendance = permission_justify(newdate)
              attendance_saver(attendance)
              i += 1
            end
          end
        newdate += 1.days
        end
      else
        i = 0
        newdate = @date.to_date
        while i < @days_quantity
          if !user_non_working_days.map {|nw| nw.date}.include?(newdate)
            if newdate.wday != 0
              attendance = permission_justify(newdate)
              attendance_saver(attendance)
              i += 1
            end
          end
          newdate += 1.days
        end
      end
    end

    def vacation_justify newdate
      attendance = @user.attendances.where(date: newdate).first_or_initialize
      attendance.present = false
      attendance.vacation = true
      attendance.justified = true
      attendance.no_category_alert = true
      attendance.justificable_id = @object.id
      attendance.check_in = nil
      attendance.check_out = nil
      attendance.justificable_type = "UserVacation"
      attendance.work_time = 8.0
      return attendance
    end

    def permission_justify newdate
      attendance = @user.attendances.where(date: newdate).first_or_initialize
      attendance.vacation = false
      attendance.justificable_id = @object.id
      attendance.justificable_type = "Permission"
      attendance.present = false
      attendance.justified = true
      attendance.no_category_alert = true
      attendance.check_in = nil
      attendance.check_out = nil
      attendance.work_time = @object.reason == "Suspensión" ? 0 : 8.0
      return attendance
    end

    def attendance_saver attendance
      #if attendance.save
      #  pp "todo ok"
      #  #attendance.non_present_user.destroy unless attendance.non_present_user.nil?
      #else
      #  pp "mal #{attendance.id}"
      #end
    end


  end
end
