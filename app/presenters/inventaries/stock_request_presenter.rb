class StockRequestPresenter < BasePresenter
	presents :request
	delegate :store_line, to: :request

	def number
		content_tag :strong do
			concat(request.number)
		end
	end

	def user
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag request.user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{request.user.name}".html_safe, "#"
	end

	def reason
		handle_none(request.reason)
	end

	def date
		I18n.l(request.date, format: :short)
	end

	def due_date
		I18n.l(request.due_date, format: :short)
	end

	def state
		case request.state
		when "Solicitado"
			span = 'info'
		when "Aprobado"
			span = 'success'
		when "Rechazado"
			span = 'warning'
		when "Entregado"
			span = 'primary'
		when "Anulado"
			span = 'danger'	
		end

		html = <<-HTML
		<span class='badge-#{span} rounded p-2 small'>#{request.state}</span>
		HTML
		return html.html_safe
	end

	def urgency
		case request.urgency.to_i
		when 1..3
			span = 'success'
		when 4..6
			span = 'info'
		when 7..9
			span = 'warning'
		when 10
			span = 'danger'
		end
		html = <<-HTML
		<span class='badge-#{span} rounded p-2 small'>#{request.urgency.to_i}</span>
		HTML

		return html.html_safe
	end
	
	def action_links
		external_id = store_line.store_id
		content_tag :div do
			concat(link_to_show stores_stock_request_path(request.id, external_id: external_id))
			concat(link_to_edit edit_stores_stock_request_path(request.id, external_id: external_id))
			concat(link_to_destroy(stores_stock_request_path(request.id, external_id: external_id)))
		end
	end

end