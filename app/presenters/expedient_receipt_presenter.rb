class ExpedientReceiptPresenter < SaleApplicationPresenter
	presents :receipt
	delegate :client_payment_order, to: :receipt

	def state
		case receipt.state
		when "Pendiente"
			color = 'warning'
		when "Aprobado"
			color = 'success'
		when "Anulado"
			color = 'danger'
		when "Rechazado"
			color = 'dark'
		end
		super(color, receipt.state)
	end

	def action_links
		content_tag :div, class: 'text-center w-100' do
			concat(link_to_pdf [receipt, {format: :pdf}]) if receipt.confirmed?
			concat(link_to_edit [:edit, receipt])
			concat(link_to_destroy receipt) if receipt.pending?
		end
	end
end
