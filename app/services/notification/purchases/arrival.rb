class Notification::Purchases::Arrival < NotificationMaker

    def for_created
      title = "Se registro la llegada de stock en estado '#{document.state}'"
      body = "La llegada de stock Nº #{document.number} asignada al proveedor #{document.supplier.name} fue generada y se encuentra en estado #{document.state}."
      super(title, body)
      Activity::Purchases::Arrival.new(document.supplier.set_activity(current_user), document).for_new
    end
  
    def for_updated
      title = "Se actualizo el estado de un remito de ingreso"
      body = "El remito de ingreso Nº #{document.number} se encuentra en estado #{document.state}"
      super(title, body)
      Activity::Purchases::Arrival.new(document.supplier.set_activity(current_user), document).for_new
    end
  
    def for_disable
      title = "Se anuló un remito de ingreso"
      body = "El remito Nº #{document.number} fue anulado"
      super(title, body)
      Activity::Purchases::Arrival.new(document.supplier.set_activity(current_user), document).for_new
    end
  
    def for_not_matching
        title = "Remito no coincide con Orden"
        body = "Los detalles registrados en el remito no coinciden con la orden de compra."
        unless users.nil?
            users.each do |user_id|
                notifications << build(title, body, document, user_id, "danger")
            end
            send_notification(notifications)
        end
    end
  
end
  