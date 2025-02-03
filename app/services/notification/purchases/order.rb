class Notification::Purchases::Order < NotificationMaker

  def for_created
		title = "Se generó una orden de compra"
    body = "La orden de compra Nº #{document.number} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Purchases::Order.new(document.supplier.set_activity(current_user), document).for_new
  end
  
  def for_updated
    title = "Se actualizo el estado de una orden de compra"
    body = "La orden de compra Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Purchases::Order.new(document.supplier.set_activity(current_user), document).for_new
  end
  
  def for_disable
    title = "Se anuló una orden de compra"
    body = "La orden Nº #{document.number} fue anulada"
    super(title, body)
    Activity::Purchases::Order.new(document.supplier.set_activity(current_user), document).for_new
  end
	
end