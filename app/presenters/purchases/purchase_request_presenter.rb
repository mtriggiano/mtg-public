class Purchases::PurchaseRequestPresenter < PurchaseApplicationPresenter
  	presents :request
  	delegate :request_type, to: :request
    delegate :init_date, to: :request
    delegate :final_date, to: :request

	def due_date
		I18n.l(request.due_date, format: :short)
	end

	def state
		case request.state
		when "Pendiente"
			span = 'warning'
		when "Aprobado"
			span = 'success'
		when "En progreso"
			span = 'primary'
		when "Finalizado"
			span = 'dark'
		end
		super(span, request.state)
	end

	def urgency
		case request.urgency.to_i
		when 1
			span = 'success'
			text = "Baja"
		when 5
			span = 'warning'
			text = "Media"
		when 10
			span = 'danger'
			text = "Alta"
		end
		handle_state(span, text)
	end

	def action_links
		content_tag :div do
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
