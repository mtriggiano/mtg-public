class Purchases::BudgetRequest < ApplicationRecord
  self.table_name = :budgets_requests

  belongs_to :purchase_request, class_name: "Purchases::PurchaseRequest", foreign_key: :request_id
  belongs_to :budget, class_name: "Purchases::Budget", foreign_key: :budget_id, inverse_of: :budgets_purchase_requests, optional: true

  validates_presence_of :purchase_request, message: "Debe asociar al menos una solicitud"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
