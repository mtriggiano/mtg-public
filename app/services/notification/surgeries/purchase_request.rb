class Notification::Surgeries::PurchaseRequest < NotificationMaker

  def for_created
		title = "Se generó una solicitud de compra"
    body = "La solicitud de compra Nº #{document.number} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    #Activity::Surgeries::PurchaseRequest.new(document.supplier.set_activity(current_user), document).for_new if document.supplier
  end

  def for_updated
    title = "Se actualizo el estado de una solicitud de compra"
    body = "La solicitud de compra Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    #Activity::Surgeries::PurchaseRequest.new(document.supplier.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló una solicitud de compra"
    body = "La solicitud Nº #{document.number} fue anulada"
    super(title, body)
    #Activity::Surgeries::PurchaseRequest.new(document.client.set_activity(current_user), document).for_new
  end
end
