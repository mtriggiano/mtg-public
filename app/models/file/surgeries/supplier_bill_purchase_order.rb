class Surgeries::SupplierBillPurchaseOrder < ExpedientBillOrder
  belongs_to :supplier_bill, class_name: "Surgeries::SupplierBill", foreign_key: :bill_id, inverse_of: :supplier_bills_purchase_orders
  belongs_to :purchase_order, class_name: "Surgeries::PurchaseOrder", foreign_key: :order_id, optional: true

  validates_presence_of :purchase_order, message: "Debe asociar al menos una orde de compra"
end
