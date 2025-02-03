class Surgeries::SupplierBillArrival < ExpedientBillArrival
	belongs_to :supplier_bill, class_name: "Surgeries::SupplierBill", foreign_key: :bill_id, inverse_of: :supplier_bills_arrivals
  	belongs_to :arrival, class_name: "Surgeries::Arrival", foreign_key: :arrival_id
end