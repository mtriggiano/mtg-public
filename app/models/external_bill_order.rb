class ExternalBillOrder < ApplicationRecord
  self.table_name = :bills_orders
  belongs_to :bill,class_name: "ExternalBill", foreign_key: :bill_id, inverse_of: :external_bills_expedient_orders
  belongs_to :expedient_order, class_name: "ExpedientOrder", optional: true, foreign_key: :order_id
  belongs_to :purchase_order, class_name: "Surgeries::PurchaseOrder", optional: true, foreign_key: :order_id

  before_validation :set_type
  validates_presence_of :expedient_order, message: "Debe asociar al menos una orden de compra"

  def set_type
    self.type = self.class.name
  end
end
