class Surgeries::SupplierRequestDetail < ExpedientRequestDetail
  include ProductDetails
  include ProductInheritance
  self.ignored_columns = %w(product_code product_supplier_code product_measurement)
  self.abstract_stock = true
  has_many :purchase_requests, ->{where type: "Surgeries::PurchaseRequest"}, through: :supplier_request
  has_many :purchase_requests_details, ->(detail){ where(product_name: detail.product_name) },through: :purchase_requests, source: :details, class_name: "Surgeries::PurchaseRequestDetail"

  TABLE_COLUMNS = {
    "Número"                  => { 'important' => false,  'fixed' => false },
    "⚫"                      => { 'important' => false,  'fixed' => false },
    'Producto'                => { 'important' => true,   'fixed' => false },
    'Cantidad solicitada'     => { 'important' => false,  'fixed' => false },
    'Cantidad aprobada'       => { 'important' => false,  'fixed' => false },
    'Especificación'          => { 'important' => false,  'fixed' => false },
    'Cotización ($)'          => { 'important' => true,   'fixed' => true },
    'Acción'                  => { 'important' => true,   'fixed' => true }
  }.freeze

  def build_child_from_product product
    super do |d|
      d.product_supplier_code = product.supplier_code(d.parent.try(:entity_id))
      d.approved_quantity = 0
    end
  end

  def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    super do |o|
      o.quantity              += sr_detail.approved_quantity.to_i - sr_detail.request_quantity.to_i
      o.approved_quantity      = self.quantity
      o.description            = sr_detail.description
    end
  end

  def build_inheritance detail
    self.product_id            =  detail.product_id
    self.product_name          =  detail.product_name
    self.quantity              =  detail.quantity - detail.inventary.available_stock
    self.approved_quantity     =  self.quantity
    self.product_measurement   =  detail.product_measurement
    self.state                 =  "Pendiente"
    return self
  end

  def info
    state_point = {steps: []}
    if arrivaled
      state_point[:steps].push({
        title: "Remito de entrada asociado", description: "El producto fue asociado a un remito de entrada con estado #{arrival_state}. Se registro el ingreso de #{arrived_quantity} #{product_measurement}"
      })
    else
      state_point[:steps].push({
        title: "Sin documento asociado", description: "Esperando que se asocie el producto a un remito de entrada."
      })
    end
    return state_point
  end

  def price
    supplier_price.to_f
  end

  def total
    supplier_price.to_f
  end

  def create_price_history
    records = []
    details.each do |detail|
      records << detail.inventary.purchase_price_histories.build(price: detail.supplier_price, entity_id: entity_id)
    end
    PurchasePriceHistory.import(records)
  end

end
