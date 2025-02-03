require 'active_support'
class NotificationMaker

	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
	include ActionDispatch::Routing::UrlFor

	attr_accessor :document, :notifications, :users, :current_user

  	def initialize(document, current_user = nil, users = nil)
	    @notifications = []
	    @document = document
	    @users = users || set_users_for_document(document.department, document)
	    @current_user = current_user
  	end

	def send_notification(notifications)
		Notification.import notifications
		notifications.each do |notification|
			link = link_to "Ver más...", notification.link
			#PrivatePub.publish_to("/magnus/#{notification.user_id}/notifications", "")
		end
	end

	def set_users_for_document(department, document)
		users = []
		users << document.company.departments.find_by_name(department).try(:user_id) #Responsable del area
		if document.try(:file)
			document.file.responsables.where(document_type: document.class.name.demodulize.snakecase).each do |responsable|
				users << responsable.user_id #Responsable designado del documento
			end
			users << document.user_id
			return users.uniq.compact
		end
	end

	def build(title, body, document, user_id, color="info", company_id=nil, link="")
		link ||= polymorphic_path([:edit, document])
	    Notification.new(
			title: title,
			body: body.html_safe,
			link: link,
			parent: 'user',
			company_id: document.try(:company_id) || company_id,
			user_id: user_id,
			date: Date.today,
			color: color)
	end

	def for_created(title="", body="")
		unless users.nil?
			users.each do |user_id|
				notifications << build(title, body, document, user_id, "info")
			end
			send_notification(notifications)
		end
	end

	def for_updated(title="", body="", color = "warning")
		unless users.nil?
			users.each do |user_id|
				notifications << build(title, body, document, user_id, color)
			end
			send_notification(notifications)
		end
	end

	def for_disable(title="", body="")
		unless users.nil?
			users.each do |user_id|
				notifications << build(title, body, document, user_id, "danger")
			end
			send_notification(notifications)
		end
	end

	#REACOMODAR TODO LO DE ABAJO

	def set_users_for_purchase_document(department, document)
		users = []
		users << document.company.departments.find_by_name(department).try(:user_id)
		users << document.purchase_file.responsables.find_by(document_type: document.class.name.snakecase).try(:user_id)
		users << document.user_id
		return users.compact
	end

	def for_open_document(document = {})
		notifications = []
		notifications << Notification.new(
			title: "Se solicita la reapertura de un documento",
			body: "El usuario #{sender.name} solicita la apertura del documento '#{document[:name]}' N°#{document[:number]}",
			link: document[:path],
			parent: 'user',
			company_id: sender.company_id,
			user_id: receiver.id,
			date: Date.today
		)
		send_notification(notifications)
	end

	def for_alert
		notifications = []
		alert.users.each do |user|
			notifications << Notification.new(
				title: "Se te asignó una tarea nueva",
				body: alert.title,
				link: "/#{alert.alertable_type.snakecase.pluralize}/#{alert.alertable_id}?view=alerts",
				parent: 'user',
				company_id: alert.company_id,
				user_id: user.id,
				date: alert.init_date
			)
		end

		send_notification(notifications)
	end

	def for_file
		notifications = []
		notifications << Notification.new(
			title: "Se le asignó el expediente Nº #{file.number}",
			body: "El expediente fue creado y delegado por #{sender.name}. Haga click en el siguiente boton para ver los detalles. #{link_to 'Ver más', polymorphic_path(file)}",
			link: polymorphic_path(file),
			parent: 'user',
			company_id: file.company_id,
			user_id: file.user_id,
			date: Date.today
		)
		send_notification(notifications)
	end


	def for_purchase_file_new_state
		notifications = []
		purchase_file.responsables.where(document_type: PurchaseFile::ASSOCIATED_STATES[purchase_file.state]).each do |resp|
			notifications << Notification.new(
				title: "Se actualizó el estado del expediente Nº #{purchase_file.number}",
				body: "El expediente ahora se encuentra #{purchase_file.state.downcase}. Haga click en el siguiente boton para ver los detalles. #{link_to 'Ver más', purchase_file_path(purchase_file.id)}",
				link: purchase_file_path(purchase_file.id),
				parent: 'user',
				company_id: purchase_file.company_id,
				user_id: resp.user_id,
				date: Date.today
			)
		end
		send_notification(notifications)
	end

	def for_file_new_state
		notifications = []
		file.responsables.where(document_type: file.class::ASSOCIATED_STATES[file.state]).each do |resp|
			notifications << Notification.new(
				title: "Se actualizó el estado del expediente Nº #{file.number}",
				body: "El expediente ahora se encuentra #{file.state.downcase}. Haga click en el siguiente boton para ver los detalles. #{link_to 'Ver más', polymorphic_path(file)}",
				link: polymorphic_path(file),
				parent: 'user',
				company_id: file.company_id,
				user_id: resp.user_id,
				date: Date.today
			)
		end
		send_notification(notifications)
	end

	def for_file_responsable
		notifications = [Notification.new(
			title: "Ahora es el encargado de #{responsable.document} del expediente Nº #{responsable.file.number}",
			body: "Haga click en el siguiente boton para ver el expediente. #{link_to 'Ver más', polymorphic_path(responsable.file)}",
			link: polymorphic_path(responsable.file),
			parent: 'user',
			company_id: responsable.file.company_id,
			user_id: responsable.user_id,
			date: Date.today
		)]
		send_notification(notifications)
	end

	def for_purchase_request(generated_by_system = false)
		notifications = []
		if generated_by_system
			notifications << Notification.new(
				title: "Stock insuficiente para OV",
				body: "La solicitud Nº #{request.number} de tipo #{request.request_type} fue generada por la ausencia de stock vinculada a la Orden de venta Nº #{request.document_orders.last.number}",
				link: polymorphic_path([:edit, request]),
				parent: 'user',
				company_id: request.company_id,
				user_id: request.user_id,
				date: Date.today
			)
		end
		if request.saved_change_to_id?
			notifications << Notification.new(
				title: "Se generó una solicitud de compra",
				body: "La solicitud Nº #{request.number} de tipo #{request.request_type} fue generada y se encuentra en estado #{request.state}.",
				link: polymorphic_path([:edit, request]),
				parent: 'user',
				company_id: request.company_id,
				user_id: request.user_id,
				date: Date.today
			)
		elsif request.saved_change_to_state?
			notifications << Notification.new(
				title: "Se actualizo el estado una solicitud de compra",
				body: "La solicitud Nº #{request.number} se encuentra en estado #{request.state}",
				link: polymorphic_path([:edit, request]),
				parent: 'user',
				company_id: request.company_id,
				user_id: request.user_id,
				date: Date.today
			)
		end
		send_notification(notifications)
	end

	def for_purchase_budget
		notifications = []
		set_users_for_purchase_document("Compras", purchase_budget).each do |user_id|
			if purchase_budget.saved_change_to_id?
				notifications << Notification.new(
					title: "Se generó un presupuesto",
					body: "El presupuesto Nº #{purchase_budget.number} del proveedor #{purchase_budget.supplier.name} fue generado y se encuentra en estado #{purchase_budget.state}.",
					link: purchase_budget_path(purchase_budget.id),
					parent: 'user',
					company_id: purchase_budget.company_id,
					date: Date.today,
					user_id: user_id
				)
			elsif purchase_budget.saved_change_to_state?
				notifications << Notification.new(
					title: "Se actualizo el estado un presupuesto de venta",
					body: "El presupuesto Nº #{purchase_budget.number} se encuentra en estado #{purchase_budget.state}",
					link: purchase_budget_path(purchase_budget.id),
					parent: 'user',
					company_id: purchase_budget.company_id,
					date: Date.today,
					user_id: user_id
				)
			end
		end
		send_notification(notifications)
	end

end
