class Sales::BillShipment < ExpedientBillShipment
	belongs_to :bill, class_name: "Sales::Bill", inverse_of: :bills_shipments
	belongs_to :shipment, class_name: "Sales::Shipment"
end