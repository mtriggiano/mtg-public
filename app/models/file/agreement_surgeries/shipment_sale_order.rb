class AgreementSurgeries::ShipmentSaleOrder < ExpedientOrderShipment

  belongs_to :shipment, class_name: "AgreementSurgeries::Shipment", foreign_key: :shipment_id, inverse_of: :shipments_sale_orders
  belongs_to :sale_order, class_name: "AgreementSurgeries::SaleOrder", foreign_key: :order_id

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
