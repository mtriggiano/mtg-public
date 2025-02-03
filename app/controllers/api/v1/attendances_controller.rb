
    class Api::V1::AttendancesController < Api::V1::ApiController
      #protect_from_forgery unless: -> { request.format.json? }
      protect_from_forgery except: [:load]
      require "json"
      # load v2
      def load
        attendance_parameters.each do |att|
          AttendanceManager::ApiReceiver.new(att).delay.perform
        end
        AttendanceManager::ResumeGenerator.new.delay.perform
        head 200
      end

      def attendance_parameters
        params.permit(_json: [:user_id, :verify_mode, :in_out_mode, :date, :work_code, :check_in, :check_out]).require(:_json)
      end
      # def save_attendance user
      #  attendance = Attendance.new(user_id: user["user_id"].to_i, date: user["date"].to_date, present: true, justified: false, vacation: false, check_time: user["date"].to_time, in_out_mode: user["in_out_mode"] )
      #  attendance.save
      # end
    end
