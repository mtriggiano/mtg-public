class Surgeries::ConsumptionPresenter < SurgeryApplicationPresenter
	presents :consumption

	def tipo
		span = consumption.shipment_type == "Oficial" ? 'success' : 'info'
		handle_state(span, consumption.shipment_type)
	end

	def state
		case consumption.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Confirmado"
			span = 'primary'
		when "Anulado"
			span = 'dark'
		end
		super(span, consumption.state)
	end

	# def action_links
	# 	content_tag :div do
	# 		concat(link_to_edit [:edit, @object])
	# 		concat(link_to_destroy @object)
	# 	end
	# end
end
