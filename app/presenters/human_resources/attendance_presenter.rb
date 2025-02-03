class AttendancePresenter < BasePresenter
  presents :attendance
  delegate :id, to: :attendance
	delegate :date, to: :attendance
	delegate :check_out, to: :attendance
	delegate :check_in, to: :attendance

  def user_name
    unless attendance.user.nil?
      link_to "#{attendance.user.name}", attendance.user
    end
  end

  def present_icon
    if attendance.present
      badge("Presente", 'success')
    else
      if (attendance.vacation || attendance.justified)
        badge("#{attendance.justification_label}", 'info')
        #badge("Vacaciones", "info")
      else
        badge("Ausente", 'danger')
      end
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

  def work_time_hs
    attendance.work_time.blank? ? "0" : attendance.work_time.round(1).to_s
  end

  def action_links
    content_tag :div do
      concat(link_to_show user_attendance_path(attendance.user_id, attendance.id), {id: "show_attendance", data:{target: "#show_attendance_modal", toggle: "modal"}})
    end
  end

end
