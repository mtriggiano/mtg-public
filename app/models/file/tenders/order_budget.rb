class Tenders::OrderBudget < ExpedientOrderBudget
	belongs_to :order, class_name: "Tenders::Order", inverse_of: :orders_budgets
	belongs_to :budget, class_name: "Tenders::Budget"
end