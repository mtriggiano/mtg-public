class ExternalShipmentStockPresenter < Surgeries::ShipmentPresenter
  def entity
    shipment.client
  end
  
  def action_links
    content_tag :div do
      concat(link_to "Registrar Entrada", new_stock_external_arrivals_path(shipment_id: @object.id)) if shipment.can_create_arrival?
    end
  end

  def store
    link_to shipment.store.name, shipment.store rescue ""
  end

  def salida
    link_to shipment, [:edit, shipment], class: 'border-animated font-weight-bold'  rescue ""
  end

  def entrada
    link_to shipment.external_arrival, [:edit, shipment.external_arrival], class: 'border-animated font-weight-bold'  rescue ""
  end

  def deposito_entrada
    link_to shipment.external_arrival.store.name, shipment.external_arrival.store rescue ""
  end

  def salida_productos
    shipment.details.map do |detail|
      sanitize("#{detail.quantity.to_i} - #{detail.product_name}")
    end.join("<br>").html_safe
  end

  def entrada_productos
    return if shipment.external_arrival.blank?
    shipment.external_arrival.details.distinct("arrival_details.id").map do |detail|
      sanitize("#{detail.quantity.to_i} - #{detail.product_name}")
    end.join("<br>").html_safe
  end

  def fecha_entrada
    return if shipment.external_arrival.blank?
    handle_date(shipment.external_arrival.date)
  end

  def estado_entrada
    return if shipment.external_arrival.blank?
		case shipment.external_arrival.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Confirmado"
			span = 'primary'
		when "Anulado"
			span = 'dark'
		end
		super(span, shipment.external_arrival.state)
  end

end
  