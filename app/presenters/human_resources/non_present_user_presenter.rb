class NonPresentUserPresenter < BasePresenter
  presents :non_present_user
  delegate :id, to: :non_present_user

  def user
    unless non_present_user.user.nil?
      link_to "#{non_present_user.user.name}", profile_user_path(non_present_user.user_id)
    else
      "Sin especificar"
    end
  end

  def user_name
    unless non_present_user.user.nil?
      link_to "#{non_present_user.user.name}", profile_user_path(non_present_user.user_id)
    else
      "Sin especificar"
    end
  end

  def date
    handle_date(non_present_user.date)
  end

  def action_links
    content_tag :div do
      concat(link_to_show non_present_user_path(non_present_user.id), {id: "show_non_present_user", data:{target: "#show_non_present_user_modal", toggle: "modal"}})
    end
  end
end
