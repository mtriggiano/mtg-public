class NotificationPresenter < BasePresenter
	presents :notification
	delegate :id, to: :notification

	def title
		content_tag :div, class: 'd-flex align-items-center' do
			concat(content_tag :div, "", class: "float-left mr-3 state-point-#{notification.color}")
			concat(notification.title.titleize)
		end
	end

	def date
		content_tag :div, class: 'text-center' do
			concat(content_tag :span, icon('fas', 'calendar'), class: 'mr-3')
			concat(I18n.l(notification.date.to_date, format: :default))
		end
	end

	def seen
		content_tag :div, class: 'text-center' do
			if notification.seen
				handle_state("success", "Vista")
			else
				handle_state("danger", "No vista")
			end
		end
	end

	def action_links
		content_tag :div, class: 'text-center' do
			link_to_show notification, {data:{target: "#show_notification_modal", toggle: "modal"}}
		end
	end
end