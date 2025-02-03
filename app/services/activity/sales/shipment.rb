class Activity::Sales::Shipment < ActivityRecord

  def for_new
		activity.photo 			    = "/images/default_user.png"
		activity.activity_type 	= "Salida"

		case document.state
		when "Pendiente"
			activity.title 		  = "Salida de stock pendiente"
			activity.body 			= "El usuario #{activity.user.name} registró en el sistema la salida de stock en estado pendiente nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			activity.title 		  = "Salida de stock aprobada"
			activity.body 			= "El usuario #{activity.user.name} aprobó la salida de stock nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Anulado"
			activity.title 		  = "Salida de stock rechazado"
			activity.body 			= "El usuario #{activity.user.name} rechazó la salida de stock nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Finalizado"
			activity.title 		  = "Salida de stock rechazada"
			activity.body 			= "El usuario #{activity.user.name} finalizó la salida de stock nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		super(activity)
  end
end
