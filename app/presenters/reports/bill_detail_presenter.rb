class Reports::BillDetailPresenter < BasePresenter
  presents :bill_detail
  delegate_missing_to :bill_detail

  def action_links
  end

  def product_name
  	link_to bill_detail.product_name, bill_detail.product
  end

  def product_code
  	bill_detail.product_code
  end

  def quantity
  	bill_detail.quantity
  end

  def number
    numero = bill_detail.bill.number || "Sin numero"
  	link_to numero, [:edit, bill_detail.bill]
  end

  def date
  	bill_detail.bill.date
  end

  def client_id_medtronic
  	bill_detail.bill.client.id_medtronic rescue ""
  end

  def client
  	bill = bill_detail.bill
  	if bill.client
	  entity_name = bill.client.try(:denomination) || bill.client.try(:name)
	  link_to entity_name, polymorphic_path(bill.client)
	end
  end

  def seller
  	bill = bill_detail.bill
	bill.sellers.uniq.map do |seller|
		link_to seller.name, seller
	end.join(", ").html_safe
  end

  def vencimiento
    bill = bill_detail.bill
  	product = bill_detail.product
  	shipments = bill.bills_shipments.map{|bills_shipment| bills_shipment.shipment }
  	batches = shipments.map{|shipment| 
  	  shipment.details.select{|detail| detail.product == product }
  	}
  	  .flatten
  	  .map{|shipment_detail| shipment_detail.batch_details }
  	  .flatten if product
  	batches.map{|batch| "#{batch.batch.due_date}" }.join(", ").html_safe if batches.present?
  end

  def product_desc
  	"EA"
  end

  def supplier
  	link_to bill_detail.product.supplier.name, bill_detail.product.supplier rescue nil
  end
end
