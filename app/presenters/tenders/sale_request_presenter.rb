class Tenders::SaleRequestPresenter < SaleApplicationPresenter
  	presents :request

	def init_date
		handle_date(request.init_date)
	end

	def final_date
		handle_date(request.final_date)
	end

	def state
		case request.state
		when "Pendiente"
			span = 'warning'
		when "Aprobado"
			span = 'success'
		when "Rechazado"
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
