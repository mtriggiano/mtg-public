class Surgeries::ConsumptionDetail < ExpedientConsumptionDetail
  attr_accessor :need_to_remove_stock
  self.ignored_columns = %w[product_measurement]
  include ProductDetails
  self.table_alias = :consumption_details
  include ProductInheritance
  belongs_to :supplier, optional: true, foreign_key: :entity_id
  has_many :shipments, ->{where type: "Surgeries::Shipment"}, through: :consumption
  has_many :shipments_details, ->(detail){ where(product_name: detail.product_name) },through: :shipments, source: :details, class_name: "Surgeries::ShipmentDetail"

  TABLE_COLUMNS = {
    "Número" => {"important" => false,  "fixed" => false},
    "⚫" => {"important" => false,  "fixed" => false},
    'Producto' => { 'important' => true,  'fixed' => false },
    'Código' => { 'important' => false, 'fixed' => false },
    'Enviado' => { 'important' => false,  'fixed' => false },
    'Consumido' => { 'important' => true,  'fixed' => false },
    'Trazabilidad' => { 'important' => true,  'fixed' => false },
    'Precio' => {'important' => true, 'fixed' => false},
    'IVA' => {'important' => true, 'fixed' => false},
    'Total' => {'important' => true, 'fixed' => false},
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze


  validates_numericality_of :quantity, greater_than_or_equal_to: 0, message: 'La cantidad debe ser mayor o igual a 0.'
  validate :unset_consumption, if: :need_to_remove_stock
  validates_associated :childs

	def unset_consumption
    begin
      if self.quantity > 0
        Stock::Manager.new(detail: self, batches: batches).unset_consumption
      else
        Stock::Manager.new(detail: self, batches: batches).delay.unset_consumption
      end
      childs.each{|child| child.need_to_remove_stock = true }
    rescue InsuficientStockError => error
      errors.add(:quantity, "Stock insuficiente")
    end
  end

  def has_batches_with_errors?
    batch_details.map { |b| b.errors.any? }.include?(true)
  end

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
      super do |d|
        d.quantity = 0
      end
  end

	def set_consumption
    begin
	     Stock::Manager.new(detail: self, batches: batches).set_consumption
       childs.each{|c| c.set_consumption}
     rescue InsuficientStockError => error
       errors.add(:quantity, "Stock insuficiente")
     rescue StandardError => e
       errors.add(:base, "Error: #{e.message}. Contacte a IT")
     end
	end

	def shipment_details
    if is_a_child?
		  Surgeries::ShipmentDetail.joins(detail: [shipment: :consumptions]).where(product_id: product_id, shipments: {consumptions_shipments: { id: parent.consumption.id}})
    else
      Surgeries::ShipmentDetail.joins(shipment: :consumptions).where(product_id: product_id, shipments: {consumptions_shipments: { id: consumption.id}})
    end
	end

  def store
    parent.store
  end

  def info
  	state_point = {steps: []}
  	if ordered
  		state_point[:steps].push({
  			title: "Orden de compra registrada",
  			description: "El producto fue asociado a una orden de compra con estado #{order_state}. Se vincularon #{order_quantity} #{product_measurement}."
  		})
  	else
  		state_point[:steps].push({
  			title: "Esperando orden de compra",
  			description: "El producto aún no fue asociado a una orden de compra."
  		})
  	end
  	return state_point
  end

  protected

  def skip_quantity_validation?
    true
  end
end
