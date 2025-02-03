class ReopenerService
	attr_accessor :object, :user
	def initialize(object, user)
		@object = object
		@user	= user
	end

	def open
		response = {result: false, opened: false, user_can: true}
		if object.can_be_opened_by?(user)
			#En caso de que el que solicita la reapertura sea el responsable del expediente o del documento
			if object.can_be_reopened?
				object.current_user = user
				object.reopen = true
				if @object.update(state: @object.class::STATES.first)
					response[:result] = true
					response[:message] = "El estado del documento fue actualizado exitosamente."
					response[:opened] = true
				else
					pp @object.errors
				end
			else
				##### SOLO PASARA CON ORDENES DE VENTA
				response[:result] = true
				response[:opened] = false
				response[:message] = "No se puede reabrir este documento ya que tiene remitos asociados y confirmados"
			end
		else
			#Si no tiene autorizacion (no es responsable), se le envia una notificacion al responsable del expediente.
			NotificationMaker.new(sender: user, receiver: object.file.user).for_open_document({
				name: object.document_name,
				number: object.number,
				path: "/#{object.class.name.snakecase.pluralize}/#{object.id}/edit"
			})
			response[:result] = true
			response[:opened] = false
			response[:message] = "Se solicito al encargado del expediente que realice la apertura del documento."
		end
		return response
	end
end
