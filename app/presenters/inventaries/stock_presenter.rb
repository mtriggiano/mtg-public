class StockPresenter < BasePresenter
	presents :stock
	delegate :store, to: :stock

	def product
		link_to "#{image_tag stock.product.images.first.try(:source), class: 'img-fluid border rounded-circle table-avatar'} #{ stock.product.name}".html_safe,  stock.product
	end

	def available
		stock.available.round(2)
	end

	def reserved
		stock.reserved.round(2)
	end

	def waiting_arraival
		#TODO
		Store.joins(transfer_notes: :details).where("stores.id = ? AND transfer_notes.state = 'Enviado' AND transfer_note_details.product_id = ?", store.id, stock.product_id).sum("transfer_note_details.quantity")
	end
	
	def action_links
		content_tag :div do
			concat(link_to_show stores_stocks_path(stock.id))
		end
	end

end