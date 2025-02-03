class StoreActivityPresenter < BasePresenter
	presents :activity

	def name
		handle_none(activity.name)
	end

	def line
		link_to activity.store_line.name, stores_external_store_line_path(activity.store_line.id, external_id: activity.store_line.store_id)
	end

	def link
		link_to "Ver detalle", activity.link
	end

	def date
		I18n.l(activity.date, format: :short)
	end

	def user
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag activity.user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{budget.user.name}".html_safe, "#"
	end
	
	def action_links
		content_tag :div do
			concat(link_to_show activity.link)
		end
	end

end