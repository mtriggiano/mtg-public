class Reports::FilePresenter < BasePresenter
  presents :file
  delegate :id, to: :file

  def action_links
  end

  def number
    link_to file.number, file
  end

  def delivery_date
    I18n.l(file.delivery_date) if file.delivery_date
  end

  def client
    link_to file.client.name, file.client
  end

  def pacient_with_number
    "#{file.pacient} Nº#{file.pacient_number}" rescue nil
  end

  def shipments
    file.expedient_shipments.map{|shipment| link_to(shipment.number, [:edit, shipment])}.join("<br>").html_safe
  end

  def sale_type
    file.try(:sale_type)
  end

  def title
    file.title
  end

  def doctor
    file.doctor
  end

  def sale_orders
    file.sale_orders.map{|sale_order| link_to(sale_order.number, [:edit, sale_order])}.join("<br>").html_safe
  end

  def sellers
    file.budgets.map{|budget| budget.seller.name if budget.seller}.compact.join(", ")
  end

  def technical
    file.technical
  end

end
