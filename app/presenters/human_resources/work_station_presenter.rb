class WorkStationPresenter < BasePresenter
  presents :work_station
  delegate :id, to: :work_station
  delegate :name, to: :work_station


  def users_quantity
    "#{work_station.users.count} empleados"
  end

  def responsable_name
    link_to "#{work_station.responsable.name}", profile_user_path(work_station.responsable)
  end

  def action_links
    content_tag :div do
      concat(link_to_show work_station_path(work_station.id), {id: "show_work_station", data:{target: "#show_work_station_modal", toggle: "modal"}})
      concat(link_to_edit edit_work_station_path(work_station.id), {id: "edit_work_station", data:{target: "#edit_work_station_modal", toggle: "modal", form: true}})
      concat(link_to_destroy work_station_path(work_station.id))
    end
  end

end
