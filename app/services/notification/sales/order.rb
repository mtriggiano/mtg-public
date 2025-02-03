class Notification::Sales::Order < NotificationMaker

  def for_created
		title = "Se generó una orden de venta"
    body = "La orden de venta Nº #{document.number} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Sales::Order.new(document.client.set_activity(current_user), document).for_new
  end
  
  def for_updated
    title = "Se actualizo el estado de una orden de venta"
    body = "La orden de venta Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Sales::Order.new(document.client.set_activity(current_user), document).for_new
  end
  
  def for_disable
    title = "Se anuló una orden de venta"
    body = "La orden Nº #{document.number} fue anulada"
    super(title, body)
    Activity::Sales::Order.new(document.client.set_activity(current_user), document).for_new
  end
	
end