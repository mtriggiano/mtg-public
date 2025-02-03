class Tenders::BillShipment < ExpedientBillShipment
	belongs_to :bill, class_name: "Tenders::Bill", inverse_of: :bill_shipments
	belongs_to :shipment, class_name: "Tenders::Shipment"
end