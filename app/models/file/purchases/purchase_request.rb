class Purchases::PurchaseRequest < ExpedientRequest
    include Notificable
    include ProductInheritance
    belongs_to  :file, class_name: "Purchases::File"
    belongs_to  :external_file, foreign_key: :external_file_id, class_name: "Expedient", optional: true
    has_many    :purchase_requests_sale_orders,
                dependent: :destroy,
                class_name: "Purchases::SaleOrderPurchaseRequest",
                foreign_key: :request_id,
                inverse_of: :purchase_request
    has_many    :purchase_requests_tender_orders,
                dependent: :destroy,
                class_name: "Purchases::TenderOrderPurchaseRequest",
                foreign_key: :request_id,
                inverse_of: :purchase_request

    # NUEVA MODIFICACION
    has_many    :purchase_requests_shipments,
                dependent: :destroy,
                class_name: "Purchases::ShipmentRequest",
                foreign_key: :request_id,
                inverse_of: :purchase_request
    has_many    :shipments, through: :purchase_requests_shipments
    # NUEVA MODIFICACION

    has_many    :sale_orders, through: :purchase_requests_sale_orders, source: :sale_order
    has_many    :tender_orders, through: :purchase_requests_tender_orders, source: :tender_order

    inherit_details_from :sale_order
    accepts_nested_attributes_for :purchase_requests_sale_orders,
                allow_destroy: :true,
                reject_if: :all_blank

    def self.search search
        return all if search.blank?
        where("requests.number ILIKE (?)", "#{search}%")
    end

    def department
        "Compras"
    end

    def assign_details_from_order order
        details.each{ |d| d.mark_for_destruction }
        order.details_without_enough_stock.each do |detail|
            det = self.details.build.build_inheritance(detail)
            det.quantity = detail.quantity - det.inventary.available_stock
            detail.childs.each do |child|
                det.childs.build.build_inheritance(child) unless child.has_enough_stock?
            end
        end
    end

    def assign_details_from_shipment shipment
        details.each{ |d| d.mark_for_destruction }
        shipment.own_details_without_enough_stock.each do |detail|

            self.details.build.build_inheritance(detail)
            shipment.details.where(product_id: detail[:product_id]).each do |det|
                det.state = false
                det.requested = true
                det.save
            end
            shipment.childs.where(product_id: detail[:product_id]).each do |det|
                det.state = false
                det.requested = true
                det.save
            end
        end
    end

    def has_pdf?
      false
    end

    def used?
      false
    end
end
