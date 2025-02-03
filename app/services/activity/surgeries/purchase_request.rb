class Activity::Surgeries::PurchaseRequest < ActivityRecord
  def for_new
		activity.photo 			      = "/images/default_user.png"
		activity.activity_type 	  = "Solicitud de compra"

		case document.state
		when "Pendiente"
			activity.title 		= "Solicitó una venta"
			activity.body 			= "El usuario #{activity.user.name} registro en el sistema el ingreso de una nueva solicitud de venta nº #{document.number} el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			activity.title 		= "Solicitud de venta aprobada"
			activity.body 			= "El usuario #{activity.user.name} aprobó la solicitud de venta nº #{document.number} el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Rechazado"
			activity.title 		= "Solicitud de venta rechazada"
			activity.body 			= "El usuario #{activity.user.name} rechazó la solicitud de venta nº #{document.number} el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end
    super(activity)
	end
end
