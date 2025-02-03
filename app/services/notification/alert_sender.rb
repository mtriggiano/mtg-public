class Notification::AlertSender < NotificationMaker
	def for_created
    title = "Tarea asignada"
    body = "El usuario #{document.user.name} le asigno la tarea '#{document.title}'."
    super(title, body)
	end

	def for_in_progress
		title = "Tarea en progreso"
    body = "La tarea '#{document.title}' se encuentra en progreso"
    for_updated(title, body, "primary")
	end

	def for_cumpliment
		title = "Tarea finalizada"
    body = "La tarea '#{document.title}' fue completada."
    for_updated(title, body, "success")
	end

	def for_disable
		title = "La tarea anulada"
    body = "La tarea '#{document.title}' fue anulada."
    for_updated(title, body, 'danger')
	end

	def build(title, body, document, user_id, color)
	    Notification.new(
			title: title,
			body: body,
			link: home_path,
			parent: 'user',
			company_id: document.company_id,
			user_id: user_id,
			date: Date.today,
			color: color)
	end
end
