class Activity::Purchases::Order < ActivityRecord
  def for_new
    activity.photo 			= "/images/default_user.png"
    activity.activity_type 	= "Orden de compra"

    case document.state
    when "Pendiente"
      activity.title 		= "Orden de compra pendiente"
      activity.body 		= "El usuario #{activity.user.name} registro en el sistema el ingreso de una nueva orden de compra nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Aprobado"
      activity.title 		= "Orden de compra aprobada"
      activity.body 		= "El usuario #{activity.user.name} aprobó la orden de compra nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Rechazado"
      activity.title 		= "Orden de compra rechazada"
      activity.body 		= "El usuario #{activity.user.name} rechazo la orden de compra nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    end

    super(activity)
	end
end