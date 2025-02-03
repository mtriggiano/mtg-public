class Activity::Surgeries::ClientBill < ActivityRecord
  def for_new
    activity.photo 			    = "/images/default_user.png"
    activity.activity_type 	= "Factura"

    case document.state
    when "Pendiente"
      activity.title 		= "Factura pendiente"
      activity.body 		= "El usuario #{activity.user.name} registro en el sistema el ingreso de una nueva factura nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Confirmado"
      activity.title 		= "Factura confirmada"
      activity.body 		= "El usuario #{activity.user.name} confirmó la factura nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Anulado"
      activity.title 		= "Factura anulada"
      activity.body 		= "El usuario #{activity.user.name} anulo la factura nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    when "Anulado parcialmente"
      activity.title 		= "Factura anulada parcialmente"
      activity.body 		= "El usuario #{activity.user.name} anulo parcialmente la factura nº #{document.number} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
    end

    super(activity)
	end
end
