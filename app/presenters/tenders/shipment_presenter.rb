class Tenders::ShipmentPresenter < TenderApplicationPresenter
  	presents :shipment

	def tender_orders_links
		shipment.orders.map do |tender_order|
			sanitize("#{link_to tender_order.number, tender_order_path(tender_order.id)}")
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
