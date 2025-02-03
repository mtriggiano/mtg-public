class Tenders::ShipmentOrder < ExpedientOrderShipment
	belongs_to :shipment, class_name: "Tenders::Shipment", inverse_of: :shipments_orders
	belongs_to :order, class_name: "Tenders::Order" , optional: true

	validates_presence_of :order, message: "Debe asociaro al menos una orde de venta"
end