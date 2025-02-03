class Inventaries::ProductValorStockPresenter < BasePresenter
  presents :product
  delegate :product_category, to: :product
  
  def action_links
    content_tag :div do      
    end
  end

  def id
    product.id
  end

  def branch
    product.branch
  end

  def name
    link_to product.name, product
  end

  def code
    product.code
  end

  def category
    product.product_category
  end

  def family
    product.family
  end

  def available_stock
    _get_stock
  end

  def supplier
    link_to product.supplier.name, product.supplier if product.supplier
  end

  def state
    if product.minimum_stock < _get_stock
      text = "Stock suficiente"
      color = "success"
    elsif product.minimum_stock >= _get_stock && _get_stock > 0
      text = "Stock Bajo"
      color= "warning"
    else
      text = "Sin stock"
      color = "danger"
    end
    super(color, text)
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

  def buy_order
    order_detail = latest_purchases_order_detail
    return unless order_detail
    link_to(order_detail.try(:order).try(:number), [:edit, order_detail.try(:order)]).html_safe
  end

  def buy_order_date
    order_detail = latest_purchases_order_detail
    return unless order_detail
    order_detail.order.created_at
  end

  def buy_price
    price = _buy_price
    number_to_currency( price, unit: "$", format: "%u %n", seperator: ',') if price
  end

  def buy_price_usd
    order_detail = latest_purchases_order_detail
    return unless order_detail
    usd_price = order_detail.try(:order).try(:usd_price) || 0 
    price = order_detail.try(:price) || 0 
    handle_currency( (price / usd_price).round(2), "$") unless usd_price.zero?
  end

  def sale_price
    price = _sale_price
    number_to_currency( price, unit: "$", format: "%u %n", seperator: ',')  if price
  end

  def sale_price_usd
    bill_detail = latest_sales_bill_detail
    return unless bill_detail
    usd_price = bill_detail.try(:expedient_bill).try(:usd_price) || 0 
    price = bill_detail.try(:price) || 0 
    handle_currency( (price / usd_price).round(2), "$")
  end

  def supplier_price
    "$#{product.supplier_price.round(2)}" if product.supplier_price
  end

  def valor_total
    total = _get_stock * _buy_price
    number_to_currency( total, unit: "$", format: "%u %n", seperator: ',')  if total
  end

  def valor_total_usd
    total = _get_stock * _buy_price_usd
    number_to_currency( total, unit: "$", format: "%u %n", seperator: ',')  if total
  end

  def _sale_price
    bill_detail = latest_sales_bill_detail
    bill_detail.try(:price) || 0
  end

  def _buy_price
    order_detail = latest_purchases_order_detail
    order_detail.try(:price) || 0
  end

  def _buy_price_usd
    order_detail = latest_purchases_order_detail
    return 0 unless order_detail
    usd_price = order_detail.try(:order).try(:usd_price) || 0 
    price = order_detail.try(:price) || 0 
    return (price / usd_price).round(2) if ! usd_price.zero?
    0
  end

  # el stock a contabilizar depende si se filtra por el deposito
  def _get_stock
    return @current_stock if @current_stock
    if params[:filtros].present? && params[:filtros][:store_id].present?
      @current_stock = product.batch_stores.select{|batch_store| batch_store.store_id == params[:filtros][:store_id].to_i }.sum(&:quantity)
    else
      @current_stock = product.available_stock
    end
  end

  private 
  def latest_purchases_order_detail
    @buy_order ||= product.purchases_order_details.select{|order_detail| order_detail.price != 0 && order_detail.order.try(:state) == "Aprobado" }.sort_by{|a| a.created_at }.last
    @buy_order
  end

  def latest_sales_bill_detail
    @sale_order ||= product.sales_bill_details.select{|bill_detail| bill_detail.price != 0 && bill_detail.expedient_bill.try(:state) == "Aprobado" }.sort_by{|a| a.created_at }.last
    @sale_order
  end

end
