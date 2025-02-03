class Purchases::PaymentOrderPresenter < PurchaseApplicationPresenter
	presents :payment_order

	def action_links
		content_tag :div do
			concat(link_to_pdf purchases_payment_order_path(payment_order.id, format: :pdf)) if payment_order.respond_to?(:imprimible?) && payment_order.imprimible?
			concat(link_to_edit edit_purchases_payment_order_path(payment_order.id))
			concat(link_to_destroy(purchases_payment_order_path(payment_order.id)))
		end
	end

	def file
		link_to payment_order.file.number, purchases_file_path(payment_order.file_id)
	end

	def number
		link_to payment_order.number, edit_purchases_payment_order_path(payment_order.id)
	end

	def state
		states = {
			"Pendiente" 	=> "warning",
			"Enviado" 		=> "info",
			"Aprobado"		=> "success",
			"Anulado"		=> "danger",
			"Finalizado" 	=> "dark"
		}
		"<span class='badge-#{states[payment_order.state]} rounded p-2 small'>#{payment_order.state}</span>".html_safe
	end

	def supplier
		link_to payment_order.supplier.name, supplier_path(payment_order.entity_id)
	end

	def total
		"$#{payment_order.total.round(2)}"
	end

	def payment_types
	  payment_order.payment_types.map(&:name).uniq.compact.join(", ")
	end

	def taxes_types
	  payment_order.taxes.map(&:tipo).uniq.compact.join(", ")
	end
end
