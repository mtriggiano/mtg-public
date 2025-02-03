class Activity::Surgeries::Consumption < ActivityRecord

  def for_new
		activity.photo 			    = "/images/default_user.png"
		activity.activity_type 	= "Entrada/Arribo"

		case document.state
		when "Pendiente"
			activity.title 		  = "Consumo pendiente"
			activity.body 			= "El usuario #{activity.user.name} registró en el sistema el consumo de cirugía en estado pendiente nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Confirmado"
			activity.title 		  = "Consumo aprobado"
			activity.body 			= "El usuario #{activity.user.name} aprobó el consumo de cirugía nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Anulado"
			activity.title 		  = "Consumo rechazado"
			activity.body 			= "El usuario #{activity.user.name} rechazó el consumo de cirugía nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Finalizado"
			activity.title 		  = "Consumo rechazado"
			activity.body 			= "El usuario #{activity.user.name} finalizó el consumo de cirugía nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		super(activity)
  end
end
