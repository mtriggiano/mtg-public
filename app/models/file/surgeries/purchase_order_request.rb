class Surgeries::PurchaseOrderRequest < ApplicationRecord
	self.table_name = :orders_requests

  	belongs_to :purchase_order, 
  				class_name: "Surgeries::PurchaseOrder",  
  				foreign_key: :order_id, 
  				inverse_of: :purchase_orders_supplier_requests
  	belongs_to :supplier_request, 
  				class_name: "Surgeries::SupplierRequest",
  				foreign_key: :request_id

  	before_validation :set_type

  	def set_type
    	self.type = self.class.name
  	end
end
