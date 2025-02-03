class ActivityRecord
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
  include ActionDispatch::Routing::UrlFor
  
  attr_accessor :activity, :document

  def initialize(activity, document)
    @activity = activity
    @document = document
	end
	
	def for_new(activity=nil)
		activity.link 			= polymorphic_path([:edit, document])
    activity.company_id = document.company_id
		unless activity.save
			pp activity.errors
		end
	end

		#BORRAR TODO LO DE ABAJO DESPUES DE ORDERNARLO
	def for_new_client
		self.activity.photo 			= "/images/default_user.png"
		self.activity.title 			= "Se creo el cliente"
		self.activity.body 				= "El usuario #{self.activity.user.name} registro en el sistema el ingreso de un nuevo cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		self.activity.activity_type 	= "Nuevo registro"
		self.activity.link 				= "/clients/#{self.activity.activitable_id}"
		self.activity.save
	end

	def for_saved_client
		self.activity.photo 			= "/images/default_user.png"
		self.activity.title 			= "Se actualizó el cliente"
		self.activity.body 				= "El usuario #{self.activity.user.name} registro en el sistema una actualización al cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		self.activity.activity_type 	= "Actualización a registro"
		self.activity.link 				= "/clients/#{self.activity.activitable_id}"
		self.activity.save
	end

	def for_new_supplier
		self.activity.photo 			= "/images/default_user.png"
		self.activity.title 			= "Se creo el proveedor"
		self.activity.body 				= "El usuario #{self.activity.user.name} registro en el sistema el ingreso de un nuevo proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		self.activity.activity_type 	= "Nuevo registro"
		self.activity.link 				= "/suppliers/#{self.activity.activitable_id}"
		self.activity.save
	end

	def for_saved_supplier
		self.activity.photo 			= "/images/default_user.png"
		self.activity.title 			= "Se actualizó el proveedor"
		self.activity.body 				= "El usuario #{self.activity.user.name} registro en el sistema una actualización al proveedor el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		self.activity.activity_type 	= "Actualización a registro"
		self.activity.link 				= "/suppliers/#{self.activity.activitable_id}"
		self.activity.save
	end

	def for_new_request state
		self.activity.photo 			= "/images/default_user.png"
		self.activity.activity_type 	= "Solicitud de venta"
		self.activity.link 				= parent[:link]

		case state
		when "Pendiente"
			self.activity.title 		= "Solicitó una venta"
			self.activity.body 			= "El usuario #{self.activity.user.name} registro en el sistema el ingreso de una nueva solicitud de venta nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			self.activity.title 		= "Solicitud de venta aprobada"
			self.activity.body 			= "El usuario #{self.activity.user.name} aprobó la solicitud de venta nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Rechazado"
			self.activity.title 		= "Solicitud de venta rechazada"
			self.activity.body 			= "El usuario #{self.activity.user.name} rechazó la solicitud de venta nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		self.activity.save
	end

	def for_new_budget state
		self.activity.photo 			= "/images/default_user.png"
		self.activity.activity_type 	= "Presupuesto/Cotización"
		self.activity.link 				= parent[:link]

		case state
		when "Pendiente"
			self.activity.title 		= "Cotización pendiente"
			self.activity.body 			= "El usuario #{self.activity.user.name} registro en el sistema el ingreso de una nueva cotización nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Aprobado"
			self.activity.title 		= "Cotización aprobada"
			self.activity.body 			= "El usuario #{self.activity.user.name} aprobó la cotización nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Rechazado"
			self.activity.title 		= "Cotización rechazada"
			self.activity.body 			= "El usuario #{self.activity.user.name} rechazo la cotización nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		self.activity.save
	end

	def for_new_bill state
		self.activity.photo 			= "/images/default_user.png"
		self.activity.activity_type 	= parent[:tipo]
		self.activity.link 				= parent[:link]

		case state
		when "Pendiente"
			self.activity.title 		= "#{parent[:tipo]} pendiente"
			self.activity.body 			= "El usuario #{self.activity.user.name} registro en el sistema el ingreso de una nueva #{parent[:tipo]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Confirmado"
			self.activity.title 		= "#{parent[:tipo]} aprobada"
			self.activity.body 			= "El usuario #{self.activity.user.name} aprobó la #{parent[:tipo]} nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Anulado"
			self.activity.title 		= "#{parent[:tipo]} rechazada"
			self.activity.body 			= "El usuario #{self.activity.user.name} rechazo la #{parent[:tipo]} nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Anulado parcialmente"
			self.activity.title 		= "#{parent[:tipo]} rechazada"
			self.activity.body 			= "El usuario #{self.activity.user.name} rechazo la #{parent[:tipo]} nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		when "Enviado"
			self.activity.title 		= "#{parent[:tipo]} rechazada"
			self.activity.body 			= "El usuario #{self.activity.user.name} rechazo la #{parent[:tipo]} nº #{parent[:number]} a nombre del cliente el dia #{I18n.l(Date.today, format: :short)} a #{Time.now.strftime("%H:%M")} hs."
		end

		self.activity.save
	end
end