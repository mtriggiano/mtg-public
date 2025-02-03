class Inventaries::StoreProductPresenter < BasePresenter
  presents :product_store
  delegate_missing_to :product_store

  def id
    product_store.product_id
  end

  def quantity
    product_store.attributes['quantity'].to_f
  end

  def product_name
    link_to product_store.product_name, product_path(product_store.product_id)
  end

  def branch 
    product_store.product_branch
  end
  
  def name 
    link_to product_store.product
  end
  
  def code 
    product_store.product_code
  end
  
  def gtin 
    product_store.product_gtin
  end
  
  def state 
    if product_store.product_minimum_stock < product_store.product_available_stock
			text = "Stock suficiente"
			color = "success"
		elsif product_store.product_minimum_stock >= product_store.product_available_stock && product_store.product_available_stock > 0
			text = "Stock Bajo"
			color= "warning"
		else
			text = "Sin stock"
			color = "danger"
		end
		super(color, text)
  end
  
  def vigente 
    if product_store.product_selectable
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


  def action_links

  end

end
