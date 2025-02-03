class ExpedientShipmentDetail < ApplicationRecord

  attr_accessor :need_to_remove_stock

  self.table_name = :shipment_details
  default_scope ->{where custom_detail: false, active: true}
  belongs_to :shipment, class_name: "ExpedientShipment", optional: true
  belongs_to :gtin, optional: true
  has_many :batch_details, as: :detail, dependent: :destroy
  has_many :batches,through: :batch_details
  validates :batch_details, presence: true, on: :update, if: :product_id_exists?
  #validates_associated :batches

  before_destroy :release_gtins
  belongs_to :inventary, optional: true, foreign_key: :product_id
  belongs_to :product, optional: true, foreign_key: :product_id

  validate :remove_stock, if: :need_to_remove_stock

  STATES = []
  include ProductDetails

  TABLE_COLUMNS = {
    "Número" => {"important" => false,  "fixed" => false},
    "⚫" => {"important" => false,  "fixed" => false},
    'Producto' => { 'important' => true,  'fixed' => false },
    'Código de producto' => { 'important' => false, 'fixed' => false },
    'Marca' => { 'important' => false, 'fixed' => false },
    'Cantidad' => { 'important' => true,  'fixed' => false },
    'Trazabilidad' => { 'important' => false, 'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }

  accepts_nested_attributes_for :batch_details, reject_if: :batch_blank?, allow_destroy: true
  accepts_nested_attributes_for :batches, reject_if: :all_blank, allow_destroy: true

  scope :sin_facturas,-> { 
    left_outer_joins(shipment: :expedient_bill_shipments).where("bill_shipments.id is null")
  }

  scope :con_facturas,-> { 
    joins(shipment: :expedient_bill_shipments).distinct("shipment_details.id")
  }
  
  def product_id_exists?
    product.present?
  end 
    
  def release_gtins
    batches.update_all(shipment_detail_id: nil, state: true)
  end

  def has_batches_with_errors?
    batch_details.map { |b| b.errors.any? }.include?(true)
  end

  def available_batches
    if !product.nil?
      (batches.map{ |g| [g.serial, g.id] } + product.batches.availables.map{ |g| [g.serial, g.id] } ).uniq
    else
      []
    end
  end

  def assign_from_another(sr_detail, recharge = nil, child = false, supplier_id = nil) # sr_detail can be a child too
    super do |b|
      b.product_code        = sr_detail.product_code
      b.product_measurement = sr_detail.product_measurement || sr_detail.product.medida
      yield self if block_given?
    end
  end

  def build_child_from_product(product)
    super do |d|
      d.product_measurement = product.medida
    end
  end

  def traceable?
    batches.any?
  end

  def remove_stock
    begin
      childs.each  {|child| child.need_to_remove_stock =  true}
      Stock::Manager.new(product: product, detail: self, batches: batches, mode: "regular").remove_stock(quantity)
    rescue InsuficientStockError => e
      pp e
      errors.add(:quantity, "Stock insuficiente en el detalle #{self.inventary&.name}")
    rescue StandardError => e
      pp e
      errors.add(:quantity, "#{e.message}")
    rescue Exception => e
      errors.add(:base, "Error al confirmar, contacte un admin")
     end
	end

  def add_stock
    Stock::Manager.new(product: product, detail: self, batches: batches, mode: "rollback").add_stock(quantity, :rollback)
  end

  def store
    parent&.store
  end

  def has_stock?
    Stock::Manager.new(detail: self, batches: batches).has_enough_stock?(quantity, store.id)
  end

  def batch_blank?(attr)
    attr["batch_id"].blank? || attr["quantity"].to_i <= 0
  end

end
