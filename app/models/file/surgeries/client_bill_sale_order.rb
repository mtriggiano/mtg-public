class Surgeries::ClientBillSaleOrder < ExpedientBillOrder
  belongs_to :bill, class_name: "Surgeries::ClientBill", foreign_key: :bill_id, inverse_of: :client_bills_sale_orders
  belongs_to :sale_order, class_name: "Surgeries::SaleOrder", foreign_key: :order_id, optional: true

  validates_presence_of :sale_order, message: "Debe asociar al menos una orden de venta", if: Proc.new{|o| o.bill.is?(:bill)}
end
