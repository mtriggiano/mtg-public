class BatchPresenter < BasePresenter
	presents :batch
	delegate :id, to: :batch
	delegate :product, to: :batch
	delegate :quantity, to: :batch
  
	def code
	  batch.code
	end
  
	def id 
	  if batch.default
		icon_html = '<i class="fas fa-star" title="Lote por defecto"></i>'.html_safe
		display = "#{batch.id} #{icon_html}".html_safe
	  else
		display = batch.id
	  end
	  link_to display, [product, batch], data: { target: "#batch_modal", toggle: 'modal' }
	end
  
	def batch_stores 
	  batch.batch_stores
		.select { |bs| bs.quantity > 0 }
		.map { |bs| "#{link_to(bs.store.name, bs.store)} | #{bs.quantity}" }.join('<br>')
		.html_safe
	end
  
	def store
	  batch.store.name
	end
	
	def state
	  if batch.state
		handle_state 'success', 'Disponible'
	  else
		handle_state 'danger', 'No disponible'
	  end
	end
  
	def serial
	  batch.serial
	end
  
	def stock
	  available
	end
  
	def arrival_detail
	  if batch.arrival_detail
		arrival = batch.arrival_detail.arrival || batch.arrival_detail.parent.arrival
		link_to arrival.number, [:edit, arrival]
	  end
	end
  
	def shipment_detail
	  if batch.shipment_detail
		shipment = batch.shipment_detail.shipment || batch.shipment_detail.detail.shipment
		link_to shipment.number, [:edit, shipment]
	  end
	end
  
	def consumption_detail
	  if batch.consumption_detail
		link_to batch.consumption_detail.consumption.number, [:edit, batch.consumption_detail.consumption]
	  end
	end
  
	def devolution_detail
	  if batch.devolution_detail
		link_to batch.devolution_detail.devolution.number, [:edit, batch.devolution_detail.devolution]
	  end
	end
  
	def due_date
	  handle_date_long(batch.due_date)
	end
  
	def action_links
	  content_tag :div do
		concat(
		  link_to icon('fas', 'edit'), new_clean_stock_product_batch_path(batch.product, batch), {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary', title: "Limpiar stock"}
		)
	  end
	end
  end
  