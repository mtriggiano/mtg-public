class Sales::ShipmentPresenter < SaleApplicationPresenter
  	presents :shipment

	def sale_orders_links
		shipment.orders.map do |sale_order|
			sanitize("#{link_to sale_order.number, sale_order_path(sale_order.id)}")
		end
	end

	def tipo
		span = shipment.shipment_type == "Oficial" ? 'success' : 'info'
		handle_state(span, shipment.shipment_type)
	end

	def state
		case shipment.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Confirmado"
			span = 'primary'
		when "Anulado"
			span = 'dark'
		end
		super(span, shipment.state)
	end
end
