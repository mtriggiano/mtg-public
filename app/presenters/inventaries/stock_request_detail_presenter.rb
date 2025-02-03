class StockRequestDetailPresenter < BasePresenter
	presents :detail
	delegate :stock_request, to: :detail

	def request
		link_to stock_request.number, stores_stock_request_path(stock_request.id)
	end

	def user_id
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag stock_request.user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{stock_request.user.name}".html_safe, "#"
	end

	def product_name
		link_to "#{image_tag detail.product.images.first.try(:source), class: 'img-fluid border rounded-circle table-avatar'} #{ detail.product.name}".html_safe,  detail.product
	end

	def quantity
		detail.quantity.round(2)
	end

	def observation
		handle_none(detail.observation)
	end

	def due_date
		I18n.l(stock_request.due_date, format: :short)
	end

	def state
		case detail.state
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
		<span class='badge-#{span} rounded p-2 small'>#{detail.state}</span>
		HTML
		return html.html_safe
	end

	def state_actions
		external_id = stock_request.store_line.store_id
		content_tag :div, class: 'text-center d-block' do
			case detail.state
			when "Solicitado"
				#SI ESTA SOLICITADO SOLAMENTE PUEDE APROBARLO O RECHAZARLO
				concat(link_to "#{icon('fas', 'check')} Aprobar".html_safe, stores_stock_request_path(stock_request.id, params: {view_format: "details", external_id: external_id ,stock_request: {details_attributes: {"0" => {id: detail.id, state: "Aprobado"}}}}), remote: true, method: :patch, class: 'badge badge-success toggle-effect')
				concat(content_tag :div)
				concat(link_to "#{icon('fas', 'times')} Rechazar".html_safe, stores_stock_request_path(stock_request.id, params: {view_format: "details", external_id: external_id ,stock_request: {details_attributes: {"0" => {id: detail.id, state: "Rechazado"}}}}), remote: true, method: :patch, class: 'badge badge-warning toggle-effect text-dark')
			when "Aprobado"
				#SI ESTA APROBADO SOLAMENTE PUEDE ENTREGARLO
				link_to "#{icon('fas', 'share')} Entregar".html_safe, stores_stock_request_path(stock_request.id, params: {view_format: "details", external_id: external_id ,stock_request: {details_attributes: {"0" => {id: detail.id, state: "Entregado"}}}}), remote: true, method: :patch, class: 'badge badge-primary toggle-effect'
			when "Entregado"
				link_to "#{icon('fas', 'minus')} Anular".html_safe, stores_stock_request_path(stock_request.id, params: {view_format: "details", external_id: external_id ,stock_request: {details_attributes: {"0" => {id: detail.id, state: "Anulado"}}}}), remote: true, method: :patch, class: 'badge badge-danger toggle-effect'
			end
		end
	end

	def urgency
		case stock_request.urgency.to_i
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
		<span class='badge-#{span} rounded p-2 small'>#{stock_request.urgency.to_i}</span>
		HTML

		return html.html_safe
	end
	
	def action_links
		external_id = stock_request.store_line.store_id
		content_tag :div do
			concat(link_to_show stores_stock_request_path(stock_request.id, external_id: external_id))
			concat(link_to_edit edit_stores_stock_request_path(stock_request.id, external_id: external_id))
			concat(link_to_destroy(stores_stock_request_path(stock_request.id, external_id: external_id)))
		end
	end

end