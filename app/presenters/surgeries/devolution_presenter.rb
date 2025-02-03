class Surgeries::DevolutionPresenter < SurgeryApplicationPresenter
	presents :devolution

	def state
		case devolution.state
		when "Pendiente"
			span = 'warning'
		when "Aprobado"
			span = 'success'
		when "Reformular"
			span = 'primary'
		when "Rechazado"
			span = 'dark'
		end
		super(span, devolution.state)
	end
end
