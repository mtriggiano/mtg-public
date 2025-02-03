class Notification::Tenders::Bill < NotificationMaker

  def for_created
		title = "Se generó una factura"
    body = "La factura Nº #{document.number} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Tenders::Bill.new(document.client.set_activity(current_user), document).for_new
  end

  def for_updated
    title = "Se actualizo el estado de una factura"
    body = "La factura Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Tenders::Bill.new(document.client.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló una factura"
    body = "La factura Nº #{document.number} fue anulada"
    super(title, body)
    Activity::Tenders::Bill.new(document.client.set_activity(current_user), document).for_new
  end

end
