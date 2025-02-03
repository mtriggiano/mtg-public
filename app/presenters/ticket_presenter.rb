class TicketPresenter < BasePresenter
	presents :ticket
	delegate_missing_to :ticket

  def title
    link_to ticket.title.capitalize, ticket, class: 'border-animated font-weight-bold'
  end

  def user
    link_to ticket.user.name, ticket.user
  end

  def priority
    case
    when (1..4).include?(ticket.priority)
      color = 'success'
    when (5..8).include?(ticket.priority)
      color = 'warning'
    else
      color = 'danger'
    end
    return content_tag :span, ticket.priority, class: "text-#{color}"
  end

  def date
    handle_date(ticket.date)
  end

  def created_at
    handle_date(ticket.created_at)
  end

  def state
    case ticket.state
    when 'pending'
      content_tag :span, "Pendiente", class: "text-warning"
    when 'approved'
      content_tag :span, "Aprobado", class: "text-primary"
		when 'started'
			content_tag :span, "En proceso", class: 'text-primary'
    when 'rejected'
      content_tag :span, "Rechazado", class: "text-danger"
    when 'tested'
      content_tag :span, "Testeado", class: "text-success"
    when 'failed'
      content_tag :span, "Fallado", class: "text-danger"
    when 'finished'
      content_tag :span, "Finalizado", class: "text-success"
    end
  end

	def function_points
		case
		when (1..2).to_a.include?(ticket.function_points)
			content_tag :div, ticket.function_points, class: 'bg-success rounded-circle', style: 'width: 20px; height: 20px; text-align: center; margin-left: 15px'
		when (3..4).to_a.include?(ticket.function_points)
			content_tag :div, ticket.function_points, class: 'bg-warning rounded-circle', style: 'width: 20px; height: 20px; text-align: center; margin-left: 15px'
		when ticket.function_points == 5
			content_tag :div, ticket.function_points, class: 'bg-danger rounded-circle', style: 'width: 20px; height: 20px; text-align: center; margin-left: 15px'
		end
	end

  def action_links
    content_tag :div do
      concat(link_to_show ticket)
      concat(link_to_edit [:edit,ticket], {id: "edit_ticket", data:{target: "#edit_ticket_modal", toggle: "modal", form: true}})
      concat(link_to_destroy ticket)
    end
  end
end
