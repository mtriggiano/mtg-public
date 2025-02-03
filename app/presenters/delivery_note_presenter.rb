class DeliveryNotePresenter < PurchaseApplicationPresenter
  	presents :delivery_note

	def purchase_orders
		sanitize("#{link_to delivery_note.purchase_return.number, purchase_return_path(delivery_note.purchase_return.id)}")
	end

	def state
		case delivery_note.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Anulado"
			span = 'dark'
		end

		super(span, delivery_note.state)
	end
end
