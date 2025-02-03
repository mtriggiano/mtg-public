class Surgeries::PurchaseRequestPresenter < SurgeryApplicationPresenter
  presents :request
  delegate :request_type, to: :request

  def final_date
    I18n.l(request.final_date, format: :short)
  end

  def init_date
    I18n.l(request.init_date, format: :short)
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
      
      concat(link_to_edit [:edit, request])
      concat(link_to_destroy request)
    end
  end
end
