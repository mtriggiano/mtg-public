class Surgeries::PurchaseOrder < ExpedientOrder
    include HasDetails
    include Notificable
    include Numerable
    belongs_to :file, class_name: "Surgeries::File", foreign_key: "file_id"
    belongs_to :supplier, foreign_key: :entity_id

    has_many   :purchase_orders_consumptions,
                class_name: "Surgeries::PurchaseOrderConsumption",
                foreign_key: :order_id,
                inverse_of: :purchase_order
    has_many   :purchase_orders_supplier_requests,
                class_name: "Surgeries::PurchaseOrderRequest",
                foreign_key: :order_id,
                inverse_of: :purchase_order

    has_many    :supplier_request, through: :purchase_orders_supplier_requests
    has_many    :purchase_requests, through: :purchase_orders_purchase_requests
    has_many    :consumptions, through: :purchase_orders_consumptions
    has_many    :supplier_bill_purchase_order, class_name: "ExternalBillOrder", foreign_key: :order_id, inverse_of: :purchase_order
    has_many    :supplier_bills, through: :supplier_bill_purchase_order, source: :bill

    inherit_details_from :consumption
    share_numeration_with %w(Surgeries::PurchaseOrder Purchases::Order)
    accepts_nested_attributes_for :purchase_orders_consumptions, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :purchase_orders_supplier_requests, reject_if: :all_blank, allow_destroy: true

    def department
      "Compras"
    end

    def to_s
  		"O.C. Nº #{number}"
  	end

    def merge_with_request
        details.each{|detail| detail.merge_with_request}
    end

    def merge_with_consumption
        details.each{|detail| detail.merge_with_consumption}
    end

    def has_pdf?
      true
    end

    def pdf_name
      "orden_de_compra_#{number}"
    end

    def name
      "Cirugía: OC-#{number}"
    end
end
