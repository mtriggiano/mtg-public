class Notification::Tenders::Budget < NotificationMaker

  def for_created
    title = "Se generó un presupuesto"
    body = "El presupuesto Nº #{document.number} del cliente #{document.client.name} fue generado y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Tenders::Budget.new(document.client.set_activity(current_user), document).for_new
  end

  def for_updated
    title = "Se actualizo el estado un presupuesto de venta"
    body = "El presupuesto Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Tenders::Budget.new(document.client.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló un presupuesto de venta"
    body = "El presupuesto Nº #{document.number} fue anulado"
    super(title, body)
    Activity::Tenders::Budget.new(document.client.set_activity(current_user), document).for_new
  end
  
end