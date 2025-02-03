class Activity::Tenders::Order < ActivityRecord
  def for_new
    activity.photo 			    = "/images/default_user.png"
    activity.activity_type 	= "Orden de venta"

    case document.state
    when "Pendiente"
      activity.title 		= "Orden de venta pendiente"
      activity.body 		= "El usuario #{activity.user.name} registro en el sistema el ingreso de una nueva orden de venta nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Aprobado"
      activity.title 		= "Orden de venta aprobada"
      activity.body 		= "El usuario #{activity.user.name} aprobó la orden de venta nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Rechazado"
      activity.title 		= "Orden de venta rechazada"
      activity.body 		= "El usuario #{activity.user.name} rechazo la orden de venta nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    end

    super(activity)
	end
end