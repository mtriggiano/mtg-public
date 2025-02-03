class CashSolicitudePresenter < BasePresenter
  presents :cash_solicitude
  delegate :id, to: :cash_solicitude
  delegate :motivo, to: :cash_solicitude
  delegate :fecha, to: :cash_solicitude
  delegate :created_at, to: :cash_solicitude
  delegate :descripcion, to: :cash_solicitude

  def action_links
    content_tag :div do
      case cash_solicitude.estado
      when "Pendiente"
        concat(link_to_edit edit_cash_solicitude_path(cash_solicitude.id), {id: "edit_cash_solicitude", data:{target: "#edit_cash_solicitude_modal", toggle: "modal", form: true}})
      when "Entregado"
        concat(link_to "Informe de gastos", complete_cash_solicitude_path(cash_solicitude.id), { id: "complete_cash_solicitude" })
      end
    end
  end

  def codigo
    content_tag :div do
      concat(link_to cash_solicitude.codigo, cash_solicitude_path(cash_solicitude.id))
    end
  end

  def comprobantes
    content_tag :div do
      cash_solicitude.expense_details.each do |ed|
        concat( "#{ed.codigo_comprobante}, " )
      end
    end
  end

  def descrip_comprobantes
    content_tag :div do
      cash_solicitude.expense_details.each do |ed|
        concat( "#{ed.descripcion}, " )
      end
    end
  end

  def rendicion
    cash_solicitude.cash_refund&.fecha
  end

  def estado
    case cash_solicitude.estado
    when "Pendiente"
      handle_state("warning", "Pendiente")
    when "Aprobado"
      handle_state("info", "Aprobado")
    when "Anulado"
      handle_state("danger", "Anulado")
    when "Entregado"
      handle_state("primary", "Entregado")
    when "Listo"
      handle_state("success", "Listo")
    end
  end

  def retiro
    cash_solicitude.cash_withdrawal.fecha if cash_solicitude.cash_withdrawal
  end
end
