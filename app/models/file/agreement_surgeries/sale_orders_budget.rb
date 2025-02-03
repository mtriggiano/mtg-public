class AgreementSurgeries::SaleOrdersBudget < ApplicationRecord
  self.table_name = :orders_budgets
  belongs_to :sale_order, class_name:"AgreementSurgeries::SaleOrder", foreign_key: :order_id, inverse_of: :sale_orders_budgets
  belongs_to :budget, class_name: "AgreementSurgeries::Budget"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end