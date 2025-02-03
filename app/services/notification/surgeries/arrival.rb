class Notification::Surgeries::Arrival < NotificationMaker

  def for_created
    title = "Se registro el ingreso de stock"
    body = "El arribo Nº #{document.number} del proveedor #{document.supplier.name} fue generado y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Surgeries::Arrival.new(document.supplier.set_activity(current_user), document).for_new
  end

  def for_updated
    title = "Se actualizo el estado de un arribo"
    body = "El arribo Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Surgeries::Arrival.new(document.supplier.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló un arribo"
    body = "El arribo Nº #{document.number} fue anulado"
    super(title, body)
    Activity::Surgeries::Arrival.new(document.supplier.set_activity(current_user), document).for_new
  end

end
