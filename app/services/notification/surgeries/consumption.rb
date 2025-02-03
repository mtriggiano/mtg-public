class Notification::Surgeries::Consumption < NotificationMaker

  def for_created
    title = "Se registro un consumo de cirugía"
    body = "El consumo Nº #{document.number} del cliente #{document.client.name} fue generado y se encuentra en estado #{document.state}."
    super(title, body)
    Activity::Surgeries::Consumption.new(document.client.set_activity(current_user), document).for_new
  end

  def for_updated
    title = "Se actualizo un consumo de cirugía"
    body = "El consumo Nº #{document.number} se encuentra en estado #{document.state}"
    super(title, body)
    Activity::Surgeries::Consumption.new(document.client.set_activity(current_user), document).for_new
  end

  def for_disable
    title = "Se anuló un consumo de cirugía"
    body = "El consumo Nº #{document.number} fue anulado"
    super(title, body)
    Activity::Surgeries::Consumption.new(document.client.set_activity(current_user), document).for_new
  end

end
