class CirguryBoxPresenter < BasePresenter
	presents :cirgury_box
	delegate :product_category, to: :cirgury_box


	def action_links
		content_tag :div do
			concat(link_to_show cirgury_box_path(cirgury_box.id))
			concat(link_to_edit edit_cirgury_box_path(cirgury_box.id), {id: "edit_product"})
			concat(link_to_destroy(cirgury_box_path(cirgury_box.id)))
		end
	end


	def category
		if cirgury_box.product_category_id.blank?
			"Sin categoría"
		else
			link_to product_category.name, product_category
		end
	end

	def suppliers
		cirgury_box.suppliers.map(&:name).join(", ")
	end

	def name
		link_to "#{image_tag primary_photo, class: 'img-fluid border rounded-circle table-avatar'} #{cirgury_box.name}".html_safe, cirgury_box
	end

	def primary_photo
		if !cirgury_box.images.blank?
			cirgury_box.images.first.try(:source)
		else
			"/images/attachment.png"
		end
	end

	def code
		handle_none(cirgury_box.code)
	end

	# def price
	# 	"$#{cirgury_box.price.round(2)}"
	# end

	def price
		if cirgury_box.historical_purchase_prices.blank?
			"$0"
		else
	  	"$#{cirgury_box.historical_purchase_prices.last.price}"
		end
	end


	def supplier_code
		handle_none cirgury_box.supplier_code
	end

	def supplier_price
		if cirgury_box.supplier_price.blank?
			"Sin especificar"
		else
			"$#{cirgury_box.supplier_price.round(2)}"
		end
	end

	def margin_gain
		if product.margin_gain.blank?
			"Sin especificar"
		else
			"#{cirgury_box.margin_gain.round(2)}%"
		end
	end

	def gross_price
		if cirgury_box.gross_price.blank?
			"Sin especificar"
		else
			"$#{cirgury_box.gross_price.round(2)}"
		end
	end

	def iva_aliquot
		if cirgury_box.iva_aliquot.blank?
			"Sin especificar"
		else
			"#{Afip::ALIC_IVA.map{|c,v| v if c == cirgury_box.iva_aliquot}.compact.join()}%"
		end
	end

	def measurements
		"#{cirgury_box.measurement} #{Product::MEASUREMENT_UNITS[cirgury_box.measurement_unit]}"
	end

	def minimum_stock
		html = <<-HTML
		<span class='badge-info badge-pill'>
			#{icon('fas', 'cube')}
			#{cirgury_box.minimum_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

	def available_stock
		if cirgury_box.minimum_stock < cirgury_box.available_stock
			badge = "badge-success"
		elsif cirgury_box.minimum_stock = cirgury_box.available_stock
			badge = "badge-warning"
		else
			badge = "badge-danger"
		end
		html = <<-HTML
		<span class='#{badge} badge-pill'>
			#{icon('fas', 'cube')}
			#{cirgury_box.available_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

	def recommended_stock
		html = <<-HTML
		<span class='badge-info badge-pill'>
			#{icon('fas', 'cube')}
			#{cirgury_box.recommended_stock || 0.0}
		</span>
		HTML
		return html.html_safe
	end

end
