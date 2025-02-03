class Surgeries::PurchaseRequest < ExpedientRequest
  include Notificable
  belongs_to  :file, class_name: "Surgeries::File"
  has_many    :purchase_requests_sale_orders,
                dependent: :destroy,
                class_name: "Surgeries::PurchaseRequestSaleOrder",
                foreign_key: :request_id,
                inverse_of: :purchase_request
  has_many    :sale_orders, through: :purchase_requests_sale_orders
  has_many    :purchase_requests_shipments,
                dependent: :destroy,
                class_name: "Surgeries::ShipmentRequest",
                foreign_key: :request_id,
                inverse_of: :purchase_request
  has_many    :shipments, through: :purchase_requests_shipments

  has_many    :purchase_requests_supplier_requests,
                dependent: :destroy,
                class_name: "Surgeries::PurchaseRequestSupplierRequest",
                foreign_key: :purchase_request_id,
                inverse_of: :purchase_reques

  inherit_details_from :shipments

  accepts_nested_attributes_for :purchase_requests_shipments, reject_if: :all_blank, allow_destroy: true
  has_many :all_details, class_name: "Surgeies::PurchaseRequestDetail", foreign_key: :request_id

  def self.search search
    return all if search.blank?
    where("requests.number ILIKE (?)", "#{search}%")
  end

  def department
    "Compras"
  end

  def to_s
		"Solicitud Nº #{number}"
	end

  def assign_details_from_shipment shipment
		details.each{ |d| d.mark_for_destruction }
    shipment.supplier_details_without_enough_stock.each do |detail|
      detail.automatic_requested_quantity = detail.quantity
      detail.save!
    	det = self.details.build.build_inheritance(detail)
  		detail.childs.each do |child|
  			det.childs.build.build_inheritance(child) unless child.own?
  	  end
    end
  end

  def has_pdf?
    false
  end

end
