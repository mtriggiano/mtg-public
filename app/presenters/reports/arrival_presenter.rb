class Reports::ArrivalPresenter < BasePresenter
	presents :arrival
	delegate_missing_to :arrival

  def supplier_bills
    arrival.bills.map do |b|
      link_to b.full_number, [:edit, b]
    end.join(", ").html_safe
  end

  def purchase_orders
    arrival.expedient_orders.map do |eo|
      link_to(eo.number, [:edit, eo])
    end.join(", ").html_safe
  end

  def delivered_shipments
    delivered_shipments = arrival.try(:delivered_shipments)
    if delivered_shipments.nil?
      content_tag(:div, icon('fas', 'minus'), class: 'text-secondary')      
    elsif delivered_shipments
      content_tag(:div, icon('fas', 'check'), class: 'text-success')
    else
      content_tag(:div, icon('fas', 'times'), class: 'text-danger')
    end   
  end

  def files
    arrival.expedient_orders.map do |eo|
      eo.file.try(:title)
    end.join(", ")
  end

  def action_links
    link_to_pdf external_arrival_path(arrival, {format: :pdf})
  end

  def user
    link_to arrival.user.name, arrival.user
  end

  def supplier
    link_to arrival.supplier.try(:name), arrival.supplier
  end
end
