class ExpedientPurchaseOrderConsumption < ExpedientOrderShipment
  belongs_to :purchase_order, class_name: "Surgeries::PurchaseOrder", foreign_key: :order_id, inverse_of: :expedient_purchase_orders_consumptions
  belongs_to :consumption, class_name: "Surgeries::Consumption", foreign_key: :shipment_id
end
