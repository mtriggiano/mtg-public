class Notification::Client < NotificationMaker
  def for_created
    title = "Cliente registrado"
    body = "El cliente #{document.name} fue registrado."
    super(title, body)
  end

  def for_updated
    title = "Cliente #{document.name} actualizado"
    body = "El cliente #{document.name} fue actualizado"
    super(title, body)
  end
end
