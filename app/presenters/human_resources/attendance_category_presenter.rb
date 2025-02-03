class AttendanceCategoryPresenter < BasePresenter
  presents :attendance_category
  delegate :id, to: :attendance_category
  delegate :name, to: :attendance_category
	delegate :check_out, to: :attendance_category
	delegate :check_in, to: :attendance_category

  def check_out_label
    handle_time(check_out)
  end

  def check_in_label
    handle_time(check_in)
  end

  def work_days
    days = []
    days << ["Lunes"] if attendance_category.monday
    days << ["Martes"] if attendance_category.tuesday
    days << ["Miércoles"] if attendance_category.wednesday
    days << ["Jueves"] if attendance_category.thursday
    days << ["Viernes"] if attendance_category.friday
    days << ["Sábado"] if attendance_category.saturday
    days << ["Domingo"] if attendance_category.sunday
    days.join(", ")
  end

  def late_minutes
    "#{attendance_category.late.to_i} minutos"
  end

  def action_links
    content_tag :div do
      concat(link_to_show attendance_category_path(attendance_category.id), {id: "show_attendance_category", data:{target: "#show_attendance_category_modal", toggle: "modal"}})
      concat(link_to_edit edit_attendance_category_path(attendance_category.id), {id: "edit_attendance_category", data:{target: "#edit_attendance_category_modal", toggle: "modal", form: true}})
      concat(link_to_destroy attendance_category_path(attendance_category.id))
    end
  end

end
