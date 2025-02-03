class ExpedientBillShipment < ApplicationRecord
	self.table_name = :bill_shipments
	belongs_to :expedient_bill, foreign_key: :bill_id, optional: true
	belongs_to :expedient_shipment, foreign_key: :shipment_id, optional: true
end
