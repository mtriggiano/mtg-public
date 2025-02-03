class Notification::ExpedientReceipt < NotificationMaker

  def for_created
    title = "Recibo registrado"
    body = "El recibo #{document.number} fue registrado."
    super(title, body)
  end
end
