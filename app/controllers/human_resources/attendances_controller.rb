class HumanResources::AttendancesController < ApplicationController
  expose :attendance_resume, scope: -> {current_company.attendance_resumes}
  expose :user, scope: -> {current_company.users}
  expose :attendances, -> { params[:user_id].blank? ? attendance_resume.attendances.order("attendances.date DESC").order("attendances.check_in DESC") : user.attendances.order("attendances.date DESC").order("attendances.check_in DESC") }
  expose :attendance, scope: -> {attendances}
  include Indexable
end
