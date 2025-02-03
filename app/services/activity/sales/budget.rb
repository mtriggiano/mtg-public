class Activity::Sales::Budget < ActivityRecord

  def for_new
		activity.photo 			= "/images/default_user.png"
		activity.activity_type 	= "Presupuesto/Cotización"
		activity.link 			= polymorphic_path([:edit, document])
    	activity.company_id     = document.company_id

		case document.state
		when "Pendiente"
			activity.title 		  	= "Cotización pendiente"
			activity.body 			= "El usuario #{activity.user.name} registro en el sistema el ingreso de una nueva cotización nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			activity.title 		  	= "Cotización aprobada"
			activity.body 			= "El usuario #{activity.user.name} aprobó la cotización nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Rechazado"
			activity.title 		  	= "Cotización rechazada"
			activity.body 			= "El usuario #{activity.user.name} rechazo la cotización nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		super(activity)
	end
end