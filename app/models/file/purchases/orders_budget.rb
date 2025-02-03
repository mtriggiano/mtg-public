class Purchases::OrdersBudget < ApplicationRecord
  self.table_name = :orders_budgets
  belongs_to :order, class_name: "Purchases::Order", foreign_key: :order_id, inverse_of: :orders_budgets
  belongs_to :budget, class_name: "Purchases::Budget"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
