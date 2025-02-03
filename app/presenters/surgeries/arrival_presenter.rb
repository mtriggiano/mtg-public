class Surgeries::ArrivalPresenter < SurgeryApplicationPresenter

	presents :arrival

	def state
		case arrival.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Aprobado"
			span = 'info'
		when "Anulado"
			span = 'danger'
		end
		super(span, arrival.state)
	end

	def punctuation
		pp arrival.punctuation
		case arrival.punctuation
		when 1..3
			span = 'danger'
		when 4..6
			span = 'warning'
		when 7..9
			span = 'info'
		when 10
			span = 'success'
		end
		handle_state(span, arrival.punctuation)
	end

	def action_links
    content_tag :div do
      concat(link_to_edit [:edit, arrival])
      concat(link_to_destroy arrival)
    end
  end
end
