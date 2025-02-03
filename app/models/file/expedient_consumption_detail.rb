class ExpedientConsumptionDetail < ApplicationRecord
  self.table_name = :shipment_details
  self.ignored_columns = %w[product_measurement]
  include ProductDetails
  belongs_to :consumption, class_name: "ExpedientConsumption", optional: true, foreign_key: :shipment_id
  has_many :batch_details, as: :detail, dependent: :destroy
  has_many :batches, through: :batch_details

  accepts_nested_attributes_for :batch_details, reject_if: :batch_blank?, allow_destroy: true
  accepts_nested_attributes_for :batches, reject_if: :all_blank, allow_destroy: true
  STATES = [].freeze
  TABLE_COLUMNS = {
     "⚫" => {"important" => false,  "fixed" => false},
    'Producto' => { 'important' => true,  'fixed' => false },
    'Código de producto' => { 'important' => false, 'fixed' => false },
    'Cantidad' => { 'important' => true,  'fixed' => false },
    'Trazabilidad' => { 'important' => true,  'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze

  def available_batches
    if !inventary.nil?
      (batches.map{|g| [g.serial, g.id]} + inventary.batches.delivered.map { |g| [g.serial, g.id] }).uniq
    else
      []
    end
  end

  def traceable?
    batches.any?
  end

  def file
    parent.try(:file)
  end

  def assign_from_another(sr_detail, recharge = nil, child = false, supplier_id = nil) # sr_detail can be a child too
    super do |b|
      b.product_code        = sr_detail.product_code
      b.quantity            = 0
      b.sended_quantity     = sr_detail.quantity
    end
  end

  def batch_blank?(attr)
    attr["batch_id"].blank? || attr["quantity"].to_i <= 0
  end
end
