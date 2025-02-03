class Surgeries::PurchaseOrderPresenter < Purchases::OrderPresenter

	def file
  		if order.file.nil?
  			"Expediente Eliminado"
  		else
  			link_to order.file.full_name, surgeries_file_path(order.file_id)
  		end
  	end

	def number
		link_to order.number, edit_surgeries_purchase_order_path(order.id)
	end

	def action_links
		content_tag :div do
			concat(link_to_pdf surgeries_purchase_order_path(order.id, format: :pdf)) if order.respond_to?(:imprimible?) && order.imprimible?
			concat(link_to_edit edit_surgeries_purchase_order_path(order.id))
			concat(link_to_destroy(surgeries_purchase_order_path(order.id)))
		end
	end
end
