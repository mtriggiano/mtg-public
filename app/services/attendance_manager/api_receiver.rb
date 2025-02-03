module AttendanceManager
  class ApiReceiver
    def initialize(attendance)
      @data = attendance
    end

    def perform
      receive_data_from_api
    end

    private

    def receive_data_from_api
      user = User.where(active: true, talliable: true, machine_id: @data["user_id"].to_i).first
      # Obtenemos las asistencias del día
      unless user.nil?
        @last_att = user.attendances.where(date: @data["date"].to_date, check_out: nil).where.not(check_in: nil).last
        if @last_att.nil?
          build_new_att(@data, user)
        else
          set_checkout(@data, @last_att)
        end
      else
        pp "no se encuentra el usuario"
      end

    end #END METHOD

    def build_new_att(data, user)
      att_check_in = Time.new(2000,1, 1, data["date"].to_time.hour, data["date"].to_time.min)
      new_att = user.attendances.where(date: data["date"].to_date, check_in: att_check_in).first_or_initialize
      new_att.present = true
      new_att.justified = false
      new_att.vacation = false
      new_att.check_in = att_check_in
      new_att.minutes_late = 0
      new_att.attendance_resume_id = nil
      if new_att.save
        pp "attendance creada correctamente"
        new_att.check_if_late
      else
        pp "Attendance duplicada"
      end
    end

    def set_checkout data, last_att
      if I18n.l(data["date"].to_datetime, format: :time) >= I18n.l((last_att.check_in + 15.minutes).to_datetime, format: :time)
        #new_att = user.attendances.where(date: data["date"].to_date, check_out: nil).where.not(check_in: nil).last
        att_check_out = Time.new(2000,1, 1, data["date"].to_time.hour, data["date"].to_time.min)
        last_att.check_out = att_check_out
        work_time = ((last_att.check_out.to_time - last_att.check_in.to_time).to_f / 3600)
        work_time = if work_time % 1 < 0.5
          work_time.round(0)
        else
          work_time.round(1)
        end
        last_att.work_time = work_time
        last_att.save
        last_att.check_if_early
      else
        last_att.work_time = 0
        last_att.save
      end
    end
  end
end
