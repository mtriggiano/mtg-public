class Sales::OrderBudget < ExpedientOrderBudget
	belongs_to :order, class_name: "Sales::Order", inverse_of: :orders_budgets,optional: true
	belongs_to :budget, class_name: "Sales::Budget",optional: true
end