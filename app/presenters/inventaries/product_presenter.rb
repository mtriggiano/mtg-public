class ProductPresenter < BasePresenter
	presents :product
	delegate :id, to: :product
	delegate :product_category, to: :product
	delegate :gtin, to: :product
	delegate :pm, to: :product
	delegate :branch, to: :product
	delegate :family, to: :product

	def action_links
		content_tag :div do
			concat(link_to_show polymorphic_path(product))
			concat(link_to_edit polymorphic_path([:edit,product]))
			concat(link_to_destroy(product_path(product.id)))
		end
	end


	def category
		if product.product_category_id.blank?
			"Sin categoría"
		else
			link_to product_category.name, product_category, class: 'text-primary'
		end
	end

	def traceable
		if product.traceable
			handle_state 'success',"Si"
		else
			handle_state 'danger', "No"
		end
	end

	def name
		link_to product do
			concat(image_tag primary_photo, class: 'img-fluid border rounded-circle table-avatar')
			concat(content_tag :span, product.name, class: 'font-weight-bold border-animated')
		end
	end

	def primary_photo
		product.default_image
	end

	def code
		handle_none(product.code)
	end

	# def price
	# 	"$#{product.price.round(2)}"
	# end

	def price
		if product.purchase_price_histories.blank?
			"$0"
		else
	  	"$#{product.purchase_price_histories.last.price}"
		end
	end

	def supplier_price
		if product.supplier_price.blank?
			"Sin especificar"
		else
			"$#{product.supplier_price.round(2)}"
		end
	end

	def margin_gain
		if product.margin_gain.blank?
			"Sin especificar"
		else
			"#{product.margin_gain.round(2)}%"
		end
	end

	def gross_price
		if product.gross_price.blank?
			"Sin especificar"
		else
			"$#{product.gross_price.round(2)}"
		end
	end

	def iva_aliquot
		if product.iva_aliquot.blank?
			"Sin especificar"
		else
			"#{Afip::ALIC_IVA.map{|c,v| v if c == product.iva_aliquot}.compact.join()}%"
		end
	end

	def state
		if product.minimum_stock < product.available_stock
			text = "Stock suficiente"
			color = "success"
		elsif product.minimum_stock >= product.available_stock && product.available_stock > 0
			text = "Stock Bajo"
			color= "warning"
		else
			text = "Sin stock"
			color = "danger"
		end
		super(color, text)
	end

	def measurements
		"#{product.measurement} #{Product::MEASUREMENT_UNITS[product.measurement_unit]}"
	end

	def minimum_stock
		html = <<-HTML
		<span class='badge-info badge-pill'>
			#{icon('fas', 'cube')}
			#{product.minimum_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

	def available_stock
		if product.minimum_stock < product.available_stock
			badge = "badge-success"
		elsif product.minimum_stock == product.available_stock
			badge = "badge-warning"
		else
			badge = "badge-danger"
		end
		html = <<-HTML
		<span class='#{badge} badge-pill'>
			#{icon('fas', 'cube')}
			#{product.available_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

	def recommended_stock
		html = <<-HTML
		<span class='badge-info badge-pill'>
			#{icon('fas', 'cube')}
			#{product.recommended_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

	def vigente
		if product.selectable
			html = <<-HTML
			<span style="color: green">
				#{icon('fas', 'check-square')}
			</span>
			HTML

		else
			html = <<-HTML
			<span style="color: red">
				#{icon('fas', 'minus-square')}
			</span>
			HTML
		end

		h.content_tag :div, html.html_safe, class: "text-center"
	end

	def supplier
		link_to product.supplier.name, product.supplier, class: 'text-primary' rescue ""
	end

	def buy_price
		number_to_currency( product.buy_price, unit: "$", format: "%u %n", seperator: ',') 
	end

	def price_for_audits(price)
		price
	end
end
