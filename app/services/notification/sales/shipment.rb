class Notification::Sales::Shipment < NotificationMaker

  def for_created
    title = "Se registro la salida de stock en estado '#{document.state}'"
    body = "La salida de stock Nº #{document.number} al cliente #{document.client.name} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Sales::Shipment.new(document.client.set_activity(current_user), document).for_new
  end

  def for_updated
    title = "Se actualizo el estado de una salida de stock"
    body = "La salida de stock Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Sales::Shipment.new(document.client.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló un remito de salida"
    body = "El remito Nº #{document.number} fue anulado"
    super(title, body)
    Activity::Sales::Shipment.new(document.client.set_activity(current_user), document).for_new
  end

  def for_not_matching
    title = "Remito no coincide con Orden"
    body = "Los detalles registrados en el remito no coinciden con la orden de compra."
    unless users.nil?
			users.each do |user_id|
				notifications << build(title, body, document, user_id, "danger")
			end
			send_notification(notifications)
		end
  end

end
