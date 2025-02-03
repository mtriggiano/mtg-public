module Finances::CashSolicitudesHelper
  def evaluation_toggle builder, sym, on_label, off_label
    builder.input sym,
			label: false,
			input_html: {
        onchange: 'toggleRejectEvaluationReason()',
        class: 'evaluation_toggle',
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: 'danger',
					on: on_label,
					off: off_label
				}
			},
			wrapper_html: {
				class: 'flex-grow-1',
				style: 'margin-left: -1.25rem; padding-right: 1.25rem;'
			}
  end

  def cash_solicitude_state_helper estado
    case estado
    when "Pendiente"
      html = <<-HTML
			<span class="badge badge-warning">Pendiente</span>
			HTML
    when "Aprobado"
      html = <<-HTML
			<span class="badge badge-success">Aprobado</span>
			HTML
    when "Anulado"
      html = <<-HTML
			<span class="badge badge-danger">Rechazado</span>
			HTML
    when "Entregado"
      html = <<-HTML
			<span class="badge badge-primary">Entregado</span>
			HTML
    when "Listo"
      html = <<-HTML
			<span class="badge badge-success">Listo</span>
			HTML
    else
      html = <<-HTML
			<span class="badge badge-dark">ERROR</span>
			HTML
    end
    return html.html_safe
  end

  # ESTADOS = %w(Pendiente Aprobado Anulado Entregado Listo)
  def cash_solicitude_border_color_helper cash_solicitude
    case cash_solicitude.estado
    when "Pendiente"
      "border-left-warning"
    when "Aprobado"
      "border-left-info"
    when "Anulado"
      "border-left-danger"
    when "Entregado"
      "border-left-primary"
    when "Listo"
      "border-left-sucess"
    end
  end
end
