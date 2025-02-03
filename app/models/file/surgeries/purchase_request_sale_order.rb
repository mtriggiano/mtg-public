class Surgeries::PurchaseRequestSaleOrder < ExpedientOrderRequest
 
  belongs_to :purchase_request, class_name: "Surgeries::PurchaseRequest", foreign_key: :request_id, inverse_of: :purchase_requests_sale_orders
  belongs_to :sale_order, class_name: "Surgeries::SaleOrder", foreign_key: :order_id

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
