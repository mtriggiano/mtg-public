class PermissionPresenter < BasePresenter
  presents :permission
  delegate :id, to: :permission
  delegate :days, to: :permission

  def init_date_label
    handle_date(permission.init_date)
  end

  def final_date_label
    handle_date(permission.final_date)
  end

  def user_name
    unless permission.user.nil?
      link_to "#{permission.user.name}".html_safe, user_path(permission.user)
    else
      "Sin especificar"
    end
  end

  def approved_icon
    if permission.approved
      badge("Si", 'success')
    else
      badge("No", 'danger')
    end
  end

  def action_links
    content_tag :div do
      concat(link_to_show permission_path(permission.id), {id: "show_permission", data:{target: "#show_permission_modal", toggle: "modal"}})
      concat(link_to "#{icon('fas', 'check')}".html_safe, set_approve_params_permission_path(permission.id), {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary', id: "show_permission", data:{target: "#approve_permission_modal", toggle: "modal"}}) if permission.approver_id.nil?
      concat(link_to_destroy(permission_path(permission.id))) if permission.approver_id.nil?
    end
  end
end
