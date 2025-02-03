class HumanResources::AttendanceResumesController < ApplicationController
  expose :attendance_resumes, -> {current_company.attendance_resumes}
  expose :attendance_resume, scope: -> {attendance_resumes}
  include Indexable


  def import
    message = AttendanceManager::Importer.new(params[:file]).call
    if message == "true"
      redirect_to attendance_resumes_path, notice: 'Las asistencias estan siendo procesadas. Por favor espere.'
    else
      redirect_to attendance_resumes_path, alert: "#{message}"
    end
  end

end
