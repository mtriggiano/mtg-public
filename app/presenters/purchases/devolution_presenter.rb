class Purchases::DevolutionPresenter < PurchaseApplicationPresenter
	presents :devolution

	def number
		link_to devolution.number, edit_purchases_devolution_path(devolution.id)
	end

	def state
		states = {
			"Pendiente" 	=> "warning",
			"Enviado" 		=> "info",
			"Aprobado"		=> "success",
			"Anulado"		=> "danger",
			"Finalizada" 	=> "dark"
		}
		super(states[devolution.state], devolution.state)
	end
end
