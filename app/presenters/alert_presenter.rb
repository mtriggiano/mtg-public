class AlertPresenter < BasePresenter
  presents :alert
  delegate :assigned_users, to: :alert
  delegate :alertable_id, to: :alert
  delegate :id, to: :alert
  delegate :alertable_type, to: :alert

  	def action_links
		content_tag :div do
			concat(link_to_show polymorphic_path([:show, :alert, alert.alertable], alert_id: alert.id,), {id: "show_alert", data:{target: "#show_alert_modal", toggle: "modal"}})
			concat(link_to_edit polymorphic_path([:edit, :alert, alert.alertable], alert_id: alert.id), {id: "edit_alert", data:{target: "#edit_alert_modal", toggle: "modal", form: true}})
			concat(link_to_destroy([:destroy, :alert, alert.alertable, alert_id: alert.id, id: alert.alertable_id]))
		end
	end

	def users
		content_tag :tr do
			assigned_users.each do |user|
				concat(link_to "#{image_tag user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{user.name}".html_safe, "#")
			end
		end
	end

	def user
		link_to "#{image_tag alert.user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{alert.user.name}".html_safe, "#"
	end

	def title
		link_to alert.title, polymorphic_path([:show, :alert, alert.alertable], alert_id: id, id: alertable_id), data:{target: "#show_alert_modal", toggle: "modal"}
	end

	def state
		case alert.state
		when "Pendiente"
			"<span class='badge badge-warning'>#{alert.state}</span>".html_safe
		when "En progreso"
			"<span class='badge badge-primary'>#{alert.state}</span>".html_safe
		when "Finalizado"
			"<span class='badge badge-success'>#{alert.state}</span>".html_safe
		when "Anulado"
			"<span class='badge badge-danger'>#{alert.state}</span>".html_safe
		end
	end

	def init_date
		I18n.l(alert.init_date, format: :short)
	end

	def final_date
		I18n.l(alert.final_date, format: :short)
	end
end
