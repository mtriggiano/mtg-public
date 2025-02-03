class Purchases::FilePresenter < BasePresenter
	presents :purchase_file
	delegate :id, to: :purchase_file

	def action_links
		content_tag :div do
			concat(link_to_show purchases_file_path(purchase_file.id))
			concat(link_to_edit edit_purchases_file_path(purchase_file.id), {id: "edit_purchase_file", data:{target: "#edit_purchase_file_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(purchases_file_path(purchase_file.id)))
		end
	end

	def user_name
	  purchase_file.user.name
	end

	def number
		link_to purchase_file.number, purchase_file
	end

	def title
		link_to purchase_file.title, purchase_file
	end

	def created_at
		I18n.l(purchase_file.created_at, format: :long)
	end

	def init_date
		I18n.l(purchase_file.init_date, format: :short)
	end

	def finish_date
		return "Sin asignar" if purchase_file.finish_date.blank?
		I18n.l(purchase_file.finish_date, format: :short)
	end

	def open
		purchase_file.open ? "Si" : "No"
	end

	def state
		case purchase_file.state
		when "Finalizado"
			color = 'success'
		when "Pagado"
			color = 'success'
		when "No pagado"
			color = 'waring'
		when "En espera de remito"
			color = 'primary'
		when "En espera de orden de compra"
			color = 'secondary'
		when "En espera de solicitud"
			color = 'info'
		when "En espera de presupuesto"
			color = 'info'
		else
			color = 'info'
		end

		super(color, purchase_file.state)
	end

	def user
		link_to purchase_file.user.name, purchase_file.user
	end

	def current_location
		if purchase_file.file_movements.any?
			purchase_file.file_movements.last.department.name
		else
			return "Sin especificar"
		end
	end

end
