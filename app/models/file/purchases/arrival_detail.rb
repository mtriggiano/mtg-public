# frozen_string_literal: true

class Purchases::ArrivalDetail < ExpedientArrivalDetail
  belongs_to :arrival, foreign_key: :arrival_id, inverse_of: :details, optional: true

  has_many :purchase_orders, through: :arrival
  has_many :purchase_order_details,
           ->(detail) { where(product_id: detail.product_id) },
           through: :purchase_orders,
           source: :details
  after_save :merge_with_order, :set_product_supplier

  store_accessor :custom_attributes,
                 :sended,
                 :shipment_detail_id,
                 :shipment_state,
                 :sended_quantity

  TABLE_COLUMNS = {
    'Número' => { 'important' => false, 'fixed' => false },
    'Transacción' => { 'important' => false, 'fixed' => false },
    'Producto' => { 'important' => true, 'fixed' => false },
    'Cantidad solicitada' => { 'important' => false, 'fixed' => false },
    'Cantidad recibida' => { 'important' => true, 'fixed' => false },
    'Trazabilidad' => { 'important' => true, 'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze

  def merge_with_order
    purchase_order_details.each do |order_detail|
      order_detail.arrived             = true
      order_detail.arrival_detail_id   = id
      order_detail.arrival_state       = arrival.state
      order_detail.arrived_quantity    += quantity
      order_detail.save
    end
  end

  def info
    if sended
      { steps: [{ title: 'El producto fue enviado al cliente.', description: "El producto fue asociado a un remito de salida con estado #{shipment_state}. Se enviaron #{sended_quantity} #{product_measurement}" }] }
    else
      { steps: [{ title: 'Esperando envío al cliente.', description: 'El producto se encuentra listo para enviar al cliente. Esperando remito de salida.' }] }
    end
   end

   def childs_attributes=(attrs)
     attrs.each do |_, det|
       det["entity_id"] = entity_id
     end
     super
   end
end
