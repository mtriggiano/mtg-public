class Purchases::Order < ExpedientOrder
    include HasDetails
    include Notificable
    include Numerable
    belongs_to :file, class_name: "Purchases::File", foreign_key: "file_id"
    belongs_to :supplier, foreign_key: :entity_id

    has_many   :orders_purchase_requests,
                class_name: "Purchases::OrderPurchaseRequest",
                foreign_key: :order_id,
                inverse_of: :order
    has_many   :orders_budgets,
                class_name: "Purchases::OrdersBudget",
                foreign_key: :order_id,
                inverse_of: :order
    has_many    :budgets, through: :orders_budgets
    has_many    :purchase_requests, through: :orders_purchase_requests

    inherit_details_from :budget
    filter_details_from :purchase_request
    share_numeration_with %w(Surgeries::PurchaseOrder Purchases::Order)
    accepts_nested_attributes_for :orders_budgets, reject_if: :all_blank, allow_destroy: true


    def department
      "Compras"
    end

    def has_pdf?
      true
    end

    def pdf_name
      "orden_de_compra_#{number}"
    end

    def name
      "Compras: OC-#{number}"
    end
end
