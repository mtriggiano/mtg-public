class ExternalBillArrival < ExpedientBillArrival
	belongs_to :bill, ->{joins(:entity).where(type: "Supplier")}, class_name: "ExternalBill", foreign_key: :bill_id, inverse_of: :external_bills_external_arrivals
  belongs_to :external_arrival, class_name: "ExternalArrival", foreign_key: :arrival_id
end
