class Reports::ShipmentDetailPresenter < BasePresenter
  presents :shipment_detail
  delegate_missing_to :shipment_detail
  
  
  def date
    shipment_detail.shipment.date.strftime("%d/%m/%Y")
  end
  
  def number
    link_to shipment.number, edit_polymorphic_url(shipment)
  end

  def bill_number
    shipment_detail.shipment.expedient_bills.map{|bill| link_to bill.full_name, edit_polymorphic_url(bill) }.join("<br> ").html_safe
  end

  def bill_date
    shipment_detail.shipment.expedient_bills.map{|bill| bill.date.strftime("%d/%m/%Y") }.join("<br> ").html_safe
  end

  def shipment_number
    link_to shipment.number, edit_polymorphic_url(shipment)
  end

  def client_id_medtronic
    shipment_detail.shipment.client.id_medtronic rescue ""
  end

  def client
    shipment = shipment_detail.shipment
    client = shipment.client
    if client
      entity_name = client.try(:denomination) || client.try(:name)
      link_to entity_name, polymorphic_path(client)
    end
  end

  def product_code
    shipment_detail.product_code
  end 

  def product_desc
    "EA"
  end

  def supplier
    link_to shipment_detail.product.supplier.name, shipment_detail.product.supplier rescue nil
  end

  def quantity
    shipment_detail.quantity
  end

  def seller
    shipment = shipment_detail.shipment
    shipment.expedient_bills.map{|bill| bill.sellers }.flatten.uniq.map{|seller| link_to seller.name, seller }.join(", ").html_safe
  end

  def vencimiento
    shipment = shipment_detail.shipment
    product = shipment_detail.product
    batches = shipment.details.select{|detail| detail.product == product }
      .map{|shipment_detail| shipment_detail.batch_details }
      .flatten if product
    batches.map{|batch| "#{batch.batch.due_date}" }.join(", ").html_safe if batches.present?
  end
  
  def action_links
  
  end
end
