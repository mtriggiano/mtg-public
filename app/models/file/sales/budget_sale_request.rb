class Sales::BudgetSaleRequest < ExpedientBudgetRequest
  belongs_to :budget, class_name: "Sales::Budget", foreign_key: :budget_id, inverse_of: :budgets_sale_requests
  belongs_to :sale_request, class_name: "Sales::SaleRequest", foreign_key: :request_id, optional: true

  validates_presence_of :sale_request, message: "Debe asociar al menos una solicitud"
end
