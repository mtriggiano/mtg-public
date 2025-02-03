class Sales::ShipmentOrder < ExpedientOrderShipment
	belongs_to :shipment, class_name: "Sales::Shipment", inverse_of: :shipments_orders
	belongs_to :order, class_name: "Sales::Order", optional: true

	validates_presence_of :order, message: "Debe asociar al menos una orden de venta", if: Proc.new{|o| o.shipment.file.sale_type == "Venta regular"}
end
