class ProductCategoryPresenter < BasePresenter
	presents :product_category
	delegate :name, to: :product_category
	delegate :id, to: :product_category

	def action_links
		content_tag :div do
			concat(link_to_show product_category_path(product_category.id))
			concat(link_to_edit edit_product_category_path(product_category.id), {id: "edit_product_category", data:{target: "#edit_product_category_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(product_category_path(product_category.id)))
		end
	end

	def default_iva
		iva = Afip::ALIC_IVA.map{|c,v| v if c == product_category.default_iva}.compact.join()

		if ["0.105", "0.21", "0.27", "0"].include?(iva)
			return "#{iva.to_f * 100}%"
		else
			return iva
		end
	end

	def name
		link_to product_category.name, product_category_path(product_category.id)
	end

	def products_count
		if product_category.products_count == 0
			"Sin productos"
		else
			product_category.products_count
		end
	end

	def suppliers
		s = product_category.suppliers.map{ |b| link_to b.name, supplier_path(b.id) }.join(", ").html_safe
		if s.blank?
			return "Sin proveedores asociados"
		else
			return s
		end
	end


end
