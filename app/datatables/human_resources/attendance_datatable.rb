class HumanResources::AttendanceDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:user).includes(:user).order("attendances.date ASC, attendances.check_in ASC")
  end

end
