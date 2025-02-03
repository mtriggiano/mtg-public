class Surgeries::SupplierRequestPresenter < Surgeries::PurchaseRequestPresenter
  presents :supplier_request

  def date
    supplier_request.init_date
  end

  def entity
    link_to supplier_request.supplier.name, supplier_request.supplier
  end

  def deliver_to_hospital
  	supplier_request.deliver_to_hospital
  end

  def external_file_number
    supplier_request.file.try(:external_number)
  end

  def sale_type
    supplier_request.file.try(:sale_type)
  end

  def  bill
    supplier_request.expedient_bills.map(&:full_name).join(", ")
  end

  def consumption
    supplier_request.consumptions.map(&:number).join(", ")
  end

  def external_purchase_order
    supplier_request.file.try(:external_purchase_order_number)
  end

  def user
    supplier_request.user.name
  end

  def action_links
    content_tag :div do
      concat(link_to_pdf [supplier_request, {format: :pdf}]) if supplier_request.respond_to?(:imprimible?) && supplier_request.imprimible?
      concat(link_to_edit [:edit, supplier_request])
      concat(link_to_destroy supplier_request)
    end
  end

end
