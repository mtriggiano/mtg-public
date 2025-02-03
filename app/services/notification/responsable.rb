class Notification::Responsable < NotificationMaker

	attr_accessor :responsable, :notifications

	def initialize(responsable)
	    @notifications = []
	    @responsable = responsable
	end

  	def assign
    	title = "Ahora es el encargado de #{responsable.document} del expediente Nº #{responsable.file.number}"
    	body  = "Se le realizó una delegación de #{responsable.document} dentro del expediente #{responsable.file.number}"
    	notifications << build(title, body, responsable, responsable.user_id, "info", nil, polymorphic_path(responsable.file, view: 'documents'))
    	send_notification(notifications)
  	end
end
