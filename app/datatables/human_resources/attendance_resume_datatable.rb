class HumanResources::AttendanceResumeDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:user, user: :work_station).includes(:user, user: :work_station)
  end

end
