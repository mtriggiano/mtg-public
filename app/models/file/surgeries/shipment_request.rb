class Surgeries::ShipmentRequest < ApplicationRecord
	self.table_name = :shipment_requests
	belongs_to :shipment, class_name: "Surgeries::Shipment", inverse_of: :purchase_requests_shipments
	belongs_to :purchase_request, class_name: "Surgeries::PurchaseRequest", foreign_key: :request_id
end