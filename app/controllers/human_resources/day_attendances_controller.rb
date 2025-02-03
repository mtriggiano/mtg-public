class HumanResources::DayAttendancesController < ApplicationController

  expose :day_attendances, -> {Attendance
    .where(active: true)
    .joins(:user)
    .where(users: {active: true, talliable: true})
    .order("attendances.date DESC")
    .order("attendances.user_id")
    .order("attendances.present desc")
    .order("attendances.check_in DESC")}

    expose :day_attendance, scope: ->{day_attendances}

    skip_load_and_authorize_resource

    def index
  		if request.format.json?
  			render json: HumanResources::DayAttendanceDatatable.new(params, view_context: view_context, collection: day_attendances), status: 200
  		end
  	end

end
