class Responsable < ApplicationRecord
  self.table_name = :file_responsables

  attr_accessor :company_id

  belongs_to :file, optional: true, class_name: "Expedient"
  belongs_to :user

  after_save :notifiy_responsable
  before_create :set_active_true

  DOCUMENT = {
  	purchases: [
  		[ "Solicitud de compra", "purchase_request"],
  		[ "Presupuestos de compra", "purchase_budget"],
  		[ "Ordenes de compra", "purchase_order"],
  		[ "Comprobantes de compra", "purchase_invoice"],
      [ "Devoluciones de compra", "purchase_devolution"],
      [ "Remitos", 'purchase_arrival']
  	],
  	sales: [
  		[ "Solicitud de venta", "sale_request"],
  		[ "Presupuestos de venta", "sale_budget"],
  		[ "Ordenes de venta", "sale_order"],
  		[ "Comprobantes de venta", "sale_bill"],
      [ "Recibo", "sale_receipt"],
      [ "Remitos", 'sale_shipment']

  	],
    tenders: [
      [ "Presupuestos de venta", "tender_budget"],
      [ "Ordenes de venta", "tender_order"],
      [ "Comprobantes de venta", "tender_bill"],
      [ "Recibos", "tender_receipt"],
      [ "Remitos", 'tender_shipment']
    ],
    surgeries: [
      [ "Recetas", "surgery_prescription"],
      [ "Cotizaciones", "surgery_budget"],
      [ "Ordenes de venta", "surgery_sale_order"],
      [ "Pedidos", "surgery_request"],
      [ "Ordenes de compra", "surgery_order"],
      [ "Entradas", "surgery_arrival"],
      [ "Salidas", "surgery_shipment"],
      [ "Consumos", "surgery_consumption"],
      [ "Pagos", "surgery_supplier_bill"],
      [ "Cobros", "surgery_client_bill"]
    ]
  }

  def set_active_true
    self.active = true
  end

  def document
    Responsable::DOCUMENT[file.class.name.deconstantize.downcase.to_sym].map{|h| h.first if h.last == self.document_type}.compact.join()
  end

  def notifiy_responsable
    self.company_id = self.file.try(:company_id)
    Notification::Responsable.new(self).assign if saved_change_to_user_id?
  end

  def company_id=(value)
    @company_id = value
  end

  def company_id
    @company_id
  end
end
