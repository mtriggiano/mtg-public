# frozen_string_literal: true

class ExpedientArrivalDetail < ApplicationRecord
  attr_accessor :need_to_remove_stock
  self.table_name = :arrival_details
  self.ignored_columns = %w[product_supplier_code]
  include ProductDetails
  include Virtus.model(mass_assignment: false, constructor: false)
  STATES = ExpedientArrival::STATES

  belongs_to :arrival, class_name: 'ExpedientArrival', optional: true
  belongs_to :expedient_arrival, foreign_key: :arrival_id, optional: true
  belongs_to :inventary, foreign_key: :product_id
  has_many   :batch_details, as: :detail, dependent: :destroy
  has_many   :batches, through: :batch_details
  
  validates_presence_of :requested_quantity, message: "Debe especificar"
  validate :remove_stock, if: :need_to_remove_stock

  after_save :set_product_supplier
  store_accessor :custom_attributes,
                  :billed,
                  :bill_detail_id,
                  :bill_state,
                  :billed_quantity

  accepts_nested_attributes_for :batch_details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :batches, reject_if: :all_blank, allow_destroy: true

  attribute :entity_id, Integer

  TABLE_COLUMNS = {
    '⚫' => { 'important' => false, 'fixed' => false },
    'Transacción' => { 'important' => false, 'fixed' => false },
    'Producto' => { 'important' => true, 'fixed' => false },
    'Cantidad solicitada' => { 'important' => false, 'fixed' => false },
    'Cantidad recibida' => { 'important' => true, 'fixed' => false },
    'Unidad de medida' => { 'important' => false,  'fixed' => false },
    'Trazabilidad' => { 'important' => true, 'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze

  def set_product_supplier
    if self.product
      prod = self.product.supplier_products.where(entity_id: supplier_id).first_or_initialize
      prod.traceable = batches.any?
      prod.save
    end
  end

  def uniq_batch_per_detail
    b = []
    size = batches.reject(&:marked_for_destruction?).each do |batch|
      b << batch.code.upcase
      unless b.compact.uniq.size <= 1
        self.errors.add(:base)
        batch.errors.add(:code, "Solo puede crear un lote por concepto")
      end
   end
  end

  def supplier_id
    read_attribute(:entity_id) || parent.try(:entity_id) || parent.parent.try(:entity_id)
  end

  def has_batches_with_errors?
    batch_details.map { |b| b.errors.any? }.include?(true)
  end

  # def batch_details_attributes=(attributes)
  #   attributes.each do |_, battr|
  #     batch = Batch.find_by_id(battr[:batch_attributes][:id])
  #     if !batch.nil?
  #       quantity = battr['quantity'].to_i + batch.quantity
  #     else
  #       quantity = battr['quantity']
  #     end
  #     battr[:batch_attributes][:product_id] = product_id
  #     battr[:batch_attributes][:quantity] = quantity
  #     battr[:batch_attributes][:state] = quantity.to_i > 0
  #   end
  #   super
  # end

  def is_a_product?
    inventary&.is_a_product?
  end

  def set_batches_inventary
    console
  end

  def add_stock
    Stock::Manager.new(detail: self, batches: batches, mode: "regular").add_stock(quantity)
  end

  def remove_stock
    begin
      Stock::Manager.new(detail: self, batches: batches, mode: "rollback").remove_stock(quantity)
    rescue InsuficientStockError => error
      errors.add(:quantity, "Stock ya utilizado")
      parent.errors.add(:base, "No se puede anular porque el stock quedaría negativo.")
    end
  end

  def traceable?
    inventary&.traceable
  end

  def not_traceable?
    !traceable?
  end


  def has_gtin_with_error?
    errors[:gtin].any?
  end

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
    super do |d|
      d.requested_quantity ||= 0
      d.requested_quantity += so_detail.quantity
      d.product_measurement = so_detail.product_measurement if self.class.column_names.include?("product_measurement")
      yield self if block_given?
    end
  end

  def parent_user
    parent.try(:user_id) || parent.parent.user_id
  end

  def parent_store
    parent.try(:store_id) || parent.parent.store_id
  end

  def parent_supplier
    parent.try(:entity_id) || parent.parent.entity_id
  end

  def store
    parent.try(:store) || parent.parent.store rescue nil
  end
end
