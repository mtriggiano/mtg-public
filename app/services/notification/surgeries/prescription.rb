class Notification::Surgeries::Prescription < NotificationMaker

  def for_created
		title = "Se generó una solicitud de venta"
    body = "La solicitud Nº #{document.number} fue generada y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Surgeries::Prescription.new(document.client.set_activity(current_user), document).for_new
  end
  
  def for_updated
    title = "Se actualizo el estado de una solicitud de venta"
    body = "La solicitud Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Surgeries::Prescription.new(document.client.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló una solicitud de venta"
    body = "La solicitud Nº #{document.number} fue anulada"
    super(title, body)
    Activity::Surgeries::Prescription.new(document.client.set_activity(current_user), document).for_new
  end
  

	
end