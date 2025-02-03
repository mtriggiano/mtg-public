class Sales::BillOrder < ExpedientBillOrder
	belongs_to :bill, class_name: "Sales::Bill", inverse_of: :bills_orders
	belongs_to :order, class_name: "Sales::Order", optional: true

	validates_presence_of :order, message: "Debe asociar al menos una orden de venta", if: Proc.new{|o| o.bill.is?(:bill) && o.bill.file.sale_type == "Venta regular"}
end
