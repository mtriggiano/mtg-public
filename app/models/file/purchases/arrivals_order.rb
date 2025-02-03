class Purchases::ArrivalsOrder < ExternalArrivalOrder
  self.table_name = :arrivals_orders
  belongs_to :arrival, class_name: "Purchases::Arrival", foreign_key: :arrival_id, inverse_of: :arrivals_orders
  belongs_to :order, class_name: "Purchases::Order", optional: true

  before_validation :set_type

  validates_presence_of :order, message: "Debe asociar al menos una orden de compra"

  def set_type
    self.type = self.class.name
  end
end
