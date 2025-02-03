class Surgeries::ArrivalPurchaseRequest < ExpedientArrivalRequest
  belongs_to :arrival, class_name: "Surgeries::Arrival", foreign_key: :arrival_id, inverse_of: :arrivals_purchase_requests
  belongs_to :purchase_request, class_name: "Surgeries::PurchaseRequest", foreign_key: :request_id, optional: true

  before_validation :set_type
  validates_presence_of :purchase_request, message: "Debe asociar al menos un pedido"

  def set_type
    self.type = self.class.name
  end
end
