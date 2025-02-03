class AttendanceResumePresenter < BasePresenter
  presents :attendance_resume
  delegate :id, to: :attendance_resume
	#delegate :month, to: :attendance_resume
	delegate :year, to: :attendance_resume
	delegate :cumpliment, to: :attendance_resume


  def user_name
    unless attendance_resume.user.nil?
      link_to "#{attendance_resume.user.name}", profile_user_path(attendance_resume.user)
    end
  end

  def month
    handle_months(attendance_resume.month)
  end

  def work_station_name
    user = attendance_resume.user
    unless user.nil?
      unless user.work_station.nil?
        user.work_station.name
      else
        "Sin especificar"
      end
    else
      "Sin especificar"
    end
  end

  def file_number
    unless attendance_resume.user.nil?
      handle_none(attendance_resume.user.file_number)
    else
      "Sin especificar"
    end
  end


  def machine_id
    unless attendance_resume.user.nil?
      handle_none(attendance_resume.user.machine_id)
    else
      "Sin especificar"
    end
  end

  def user_name_without_link
    unless attendance_resume.user.nil?
      attendance_resume.user.name
    else
      "Sin usuario"
    end
  end

  def action_links
    content_tag :div do
      concat(link_to_show attendance_resume_path(attendance_resume.id))
      concat(link_to_destroy(attendance_resume_path(attendance_resume.id)))
    end
  end

  def cumpliment
    "#{attendance_resume.cumpliment.round(2)}%"
  end

  def worked_hours
    "#{attendance_resume.worked_hours.round(2)} hs"
  end

  def extra_hours
    "#{attendance_resume.extra_hours.round(2)} hs"
  end
end
