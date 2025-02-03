class ExpedientBillOrder < ApplicationRecord
  self.table_name = :bills_orders
  belongs_to :expedient_bill, foreign_key: :bill_id, optional: true
	belongs_to :expedient_order, foreign_key: :order_id, optional: true
end
