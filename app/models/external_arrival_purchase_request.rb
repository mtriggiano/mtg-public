class ExternalArrivalPurchaseRequest < ExpedientArrivalRequest
  belongs_to :arrival, class_name: "ExternalArrival", foreign_key: :arrival_id, inverse_of: :external_arrivals_expedient_requests
  belongs_to :expedient_request, class_name: "ExpedientRequest", foreign_key: :request_id, optional: true

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end