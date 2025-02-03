class Tenders::OrderPresenter < TenderApplicationPresenter
	presents :order

	def action_links
		content_tag :div do
			concat(link_to_pdf tenders_order_path(order.id, format: :pdf))
			concat(link_to_edit edit_tenders_order_path(order.id))
			concat(link_to_destroy(tenders_order_path(order.id)))
		end
	end

	def number
		link_to order.number, edit_tenders_order_path(order.id)
	end

	def client
		link_to order.client.name, client_path(order.client.id)
	end

	def state
		states = {
			"Pendiente" 	=> "warning",
			"Enviado" 		=> "info",
			"Aprobado"		=> "success",
			"Anulado"		=> "danger",
			"Finalizada" 	=> "dark"
		}
		super(states[order.state], order.state)
	end

	def expected_delivery_date
		handle_date(order.expected_delivery_date)
	end

	def paid
		text = order.paid ? "Pagado" : "No pagado"
		state = order.paid ? "success" : "danger"
		handle_state(state, text)
	end

	def total
		"$#{order.total.round(2)}"
	end
end
