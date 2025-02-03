class Tenders::BudgetSaleRequest < ExpedientBudgetRequest
  belongs_to :supplier_budget, class_name: "Tenders::SaleBudget", foreign_key: :budget_id, inverse_of: :supplier_budgets_sale_requests
  belongs_to :sale_request, class_name: "Tenders::SaleRequest", foreign_key: :request_id, optional: true

  validates_presence_of :sale_request, message: "Debe asociar al menos un pliego"
end
