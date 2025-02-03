class AgreementSurgeries::SaleOrderPresenter < BasePresenter
  presents :order

    def id
  		order.id
	end

	def number
		link_to order.number, [:edit, order], class: 'border-animated font-weight-bold' if order.number
	end

	def expected_delivery_date
		order.expected_delivery_date
	end

	def file
		link_to order.file.full_name, agreement_surgeries_file_path(order.file) if order.file
	end

	def client
		link_to order.entity.name, client_path(order.client) if order.client
	end

	def social_work
		order.file.try(:social_work)
	end

	def total
		"$#{order.total.round(2)}"
	end

	def date
		I18n.l(order.date, format: :short)
	end

	def pacient
		order.pacient
	end

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

	def action_links
		content_tag :div do
			concat(link_to_pdf [order, {format: :pdf}]) if order.respond_to?(:imprimible?) && order.imprimible?
			concat(link_to_edit [:edit, order])
			concat(link_to_destroy order)
		end
	end

end