class Activity::Tenders::Shipment < ActivityRecord

  def for_new
		activity.photo 			    = "/images/default_user.png"
		activity.activity_type 	= "Entrada/Arribo"

		case document.state
		when "Pendiente"
			activity.title 		  = "Arribo pendiente"
			activity.body 			= "El usuario #{activity.user.name} registró en el sistema el ingreso de stock en estado pendiente nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			activity.title 		  = "Arribo aprobada"
			activity.body 			= "El usuario #{activity.user.name} aprobó el arribo nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Anulado"
			activity.title 		  = "Arribo rechazado"
			activity.body 			= "El usuario #{activity.user.name} rechazó el arribo nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Finalizado"
			activity.title 		  = "Arribo rechazada"
			activity.body 			= "El usuario #{activity.user.name} finalizó el arribo nº #{document.number} a nombre del proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		super(activity)
  end
end
