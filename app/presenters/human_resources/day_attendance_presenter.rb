class HumanResources::DayAttendancePresenter < BasePresenter
  presents :attendance
  delegate :id, to: :attendance
  delegate :date, to: :attendance
  delegate :check_out, to: :attendance
  delegate :check_in, to: :attendance

  def user
    unless attendance.user.nil?
      link_to "#{attendance.user.name}", attendance.user
    end
  end

  def check_out
    handle_time(attendance.check_out)
  end

  def check_in
    handle_time(attendance.check_in)
  end

  def date
    handle_date_long(attendance.date)
  end

  def action_links
    # code
  end
end
