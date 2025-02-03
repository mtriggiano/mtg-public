class Surgeries::PurchaseRequestSupplierRequest < ApplicationRecord
	self.table_name = :purchase_request_supplier_requests

	belongs_to :supplier_request, class_name: "Surgeries::SupplierRequest", inverse_of: :supplier_requests_purchase_requests, foreign_key: :supplier_request_id
	belongs_to :purchase_request, class_name: "Surgeries::PurchaseRequest", inverse_of: :purchase_requests_supplier_requests, foreign_key: :purchase_request_id
end