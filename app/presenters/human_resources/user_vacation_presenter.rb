class UserVacationPresenter < BasePresenter
  presents :user_vacation
  delegate :id, to: :user_vacation
  delegate :days, to: :user_vacation

  def init_date_label
    handle_date(user_vacation.init_date)
  end

  def final_date_label
    handle_date(user_vacation.final_date)
  end

  def user_name
    unless user_vacation.user.nil?
      link_to "#{user_vacation.user.name}".html_safe, profile_user_path(user_vacation.user)
    else
      "Sin especificar"
    end
  end

  def approved_icon
    if user_vacation.approved
      badge("Si", 'success')
    else
      badge("No", 'danger')
    end
  end

  def action_links
    content_tag :div do
      concat(link_to_show user_vacation_path(user_vacation.id), {id: "show_user_vacation", data:{target: "#show_user_vacation_modal", toggle: "modal"}})
      concat(link_to "#{icon('fas', 'check')}".html_safe, set_approve_params_user_vacation_path(user_vacation.id), {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary', id: "approve_user_vacation", data:{target: "#approve_user_vacation_modal", toggle: "modal"}}) if user_vacation.approver_id.nil?
      concat(link_to_destroy(user_vacation_path(user_vacation.id))) if user_vacation.approver_id.nil?
    end
  end
end
