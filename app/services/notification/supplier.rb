class Notification::Supplier < NotificationMaker
  def for_created
    title = "Proveedor registrado"
    body = "El proveedor #{document.name} fue registrado"
    super(title, body)
  end

  def for_updated
    title = "Proveedor actualizado"
    body = "El proveedor #{document.name} fue actualizado"
    super(title, body)
  end
end
