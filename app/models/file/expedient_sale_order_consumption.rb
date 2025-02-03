class ExpedientSaleOrderConsumption < ExpedientOrderShipment
  belongs_to :sale_order, class_name: "Surgeries::SaleOrder", foreign_key: :order_id, inverse_of: :expedient_sale_orders_consumptions
  belongs_to :consumption, class_name: "Surgeries::Consumption", foreign_key: :shipment_id
end
