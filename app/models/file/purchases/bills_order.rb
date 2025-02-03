class Purchases::BillsOrder < ApplicationRecord
  self.table_name = :bills_orders
  belongs_to :bill, class_name: "Purchases::Bill", foreign_key: :bill_id, inverse_of: :bills_orders
  belongs_to :order, class_name: "Purchases::Order", optional: true

  before_validation :set_type
  validates_presence_of :order, message: "Debe asociar al menos una orden de compra"

  def set_type
    self.type = self.class.name
  end
end
