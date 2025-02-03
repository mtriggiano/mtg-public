class NonWorkingDayPresenter < BasePresenter
  presents :non_working_day
  delegate :id, to: :non_working_day
  delegate :users, to: :non_working_day

  def excluded_users

    unless users.blank?

      users.map(&:name).join(", ")
    else
      "Sin usuarios excluidos"
    end
  end

  def date_label
    handle_date(non_working_day.date)
  end

  def action_links
    content_tag :div do
      concat(link_to_show non_working_day_path(non_working_day.id))
      concat(link_to_destroy(non_working_day_path(non_working_day.id)))
    end
  end
end
