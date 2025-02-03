class Notification::Expedient < NotificationMaker
  attr_accessor :expedient, :notifications, :sender, :info

  def initialize(sender, expedient)
    @notifications = []
    @expedient = expedient
    @sender = sender
    @info = User.find_by_email("info@magnus.com.ar")
  end

  def for_created
    title = "Te asignaron un nuevo expediente"
    body  = "El expediente #{expedient.number} fue creado y delegado por #{sender.name}."
    notifications << build(title, body, expedient, expedient.user_id)
    send_notification(notifications)
  end

  def for_calendar_change
    title = "Se registraron modificaciones de fecha y/o entrega de un expediente"
    changed_attributes = []
    if expedient.saved_changes["surgery_end_date"]
      changed_attributes << "Fecha de cirugía"
    end
    if expedient.saved_changes["custom_attributes"]&.first.try(:[],"place")
      changed_attributes << "Lugar de entrega"
    end
    if expedient.saved_change_to_delivery_date?
      changed_attributes << "Fecha de entrega"
    end
    if expedient.saved_change_to_delivery_hour?
      changed_attributes << "Hora de entrega"
    end

    body = "El expediente #{expedient.number} fue modificado por #{sender.name}. Campos afectados: #{changed_attributes.join(", ")}."
    notifications << build(title, body, expedient, info.id)
    send_notification(notifications)
  end

  def for_attachment_change
    title = "Se subieron adjuntos de CI y/o FQ de un expediente"
    body = "El expediente #{expedient.number} contiene adjuntos de FQ y/o CI subidos por #{sender.name}, listos para su verificación."
    link = polymorphic_path(expedient, view: 'attachements')
    notifications << build(title, body, expedient, info.id, "info", nil, link)
    send_notification(notifications)
  end
end
