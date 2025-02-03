class Surgeries::ClientBillShipment < ExpedientBillShipment
	belongs_to :bill, class_name: "Surgeries::ClientBill", foreign_key: :bill_id, inverse_of: :client_bills_shipments, optional: true
  	belongs_to :shipment, class_name: "Surgeries::Shipment", foreign_key: :shipment_id, optional: true
end