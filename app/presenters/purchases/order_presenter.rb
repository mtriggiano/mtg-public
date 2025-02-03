class Purchases::OrderPresenter < PurchaseApplicationPresenter
	presents :order

	def action_links
		content_tag :div do
			concat(link_to_pdf purchases_order_path(order.id, format: :pdf)) if order.respond_to?(:imprimible?) && order.imprimible?
			concat(link_to_edit edit_purchases_order_path(order.id))
			concat(link_to_destroy(purchases_order_path(order.id)))
		end
	end

	def number
		link_to order.number, edit_purchases_order_path(order.id)
	end

	def state
		states = {
			"Pendiente" 	=> "warning",
			"Enviado" 		=> "info",
			"Aprobado"		=> "success",
			"Anulado"		=> "danger",
			"Finalizada" 	=> "dark"
		}
		"<span class='badge-#{states[order.state]} rounded p-2 small w-100 d-block text-center'>#{order.state}</span>".html_safe
	end

	def supplier
		link_to order.supplier.name, supplier_path(order.entity_id)
	end

	def shipping_included
		if order.shipping_included
			"$#{order.shipping_price.round(2)}"
		else
			"No incluye envío"
		end
	end

	def expected_delivery_date
		I18n.l(order.expected_delivery_date, format: :short)
	end	

	def file_created_at
		I18n.l(order.file.created_at, format: :short)
	end

	def paid
		"<span class='badge-#{order.paid ? 'succes' : 'danger'} rounded p-2 small w-100 d-block text-center'>#{order.paid ? 'Pagado' : 'No pagado'}</span>".html_safe
	end
end
