class ExternalArrivalOrder < ApplicationRecord
	self.table_name = :arrivals_orders
	belongs_to :arrival, class_name: "ExternalArrival", foreign_key: :arrival_id, inverse_of: :external_arrivals_expedient_requests
  	belongs_to :expedient_order, class_name: "ExpedientOrder", foreign_key: :order_id, optional: true

  	before_validation :set_type
  	validates_presence_of :expedient_order, message: "Debe asociar al menos un pedido"

  	def set_type
    	self.type = self.class.name
  	end
end