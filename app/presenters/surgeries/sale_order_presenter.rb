class Surgeries::SaleOrderPresenter < SurgeryApplicationPresenter
	presents :order

	def state
		states = {
			"Pendiente" 	=> "info",
			"Rechazado" 	=> "warning",
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
end
