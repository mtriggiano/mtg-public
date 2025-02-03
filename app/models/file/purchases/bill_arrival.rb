class Purchases::BillArrival < ExpedientBillArrival
	belongs_to :bill, class_name: "Purchases::Bill", foreign_key: :bill_id, inverse_of: :bills_arrivals
  	belongs_to :arrival, class_name: "Purchases::Arrival", foreign_key: :arrival_id
end