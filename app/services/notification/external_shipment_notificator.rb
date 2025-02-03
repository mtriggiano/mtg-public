class Notification::ExternalShipmentNotificator < NotificationMaker
	def for_created
	    title = "Se registro la salida de stock"
	    body = "La salida Nº #{document.number} del cliente #{document.client.name} fue generada y se encuentra en estado #{document.state}."
	    super(title, body)
	    Activity::Surgeries::Arrival.new(document.client.set_activity(current_user), document).for_new
	end

	def for_updated
	    title = "Se actualizo el estado de una salida"
	    body = "La salida Nº #{document.number} se encuentra en estado #{document.state}"
	    super(title, body)
	    Activity::Surgeries::Shipment.new(document.client.set_activity(current_user), document).for_new
	end

	def for_disable
	    title = "Se anuló una salida"
	    body = "La salida Nº #{document.number} fue anulada"
	    super(title, body)
	    Activity::Surgeries::Shipment.new(document.client.set_activity(current_user), document).for_new
	end
end
