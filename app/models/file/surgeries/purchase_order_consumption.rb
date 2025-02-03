class Surgeries::PurchaseOrderConsumption < ExpedientOrderShipment
  belongs_to :purchase_order, class_name: "Surgeries::PurchaseOrder", foreign_key: :order_id, inverse_of: :purchase_orders_consumptions
  belongs_to :consumption, class_name: "Surgeries::Consumption", foreign_key: :shipment_id

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
