class ExpedientDevolutionDetail < ApplicationRecord
  attr_accessor :need_to_remove_stock
  self.table_name = :devolution_details
  STATES = ["Pendiente", "Enviado", "Aprobado", "Anulado", "Finalizado"]
  belongs_to :devolution, class_name: "ExpedientDevolution", optional: true
  include Virtus.model(mass_assignment: false, constructor: false)
  attribute :current_user, User
  include ProductDetails
  has_many :batch_details, as: :detail, dependent: :destroy
  has_many :batches, through: :batch_details

  accepts_nested_attributes_for :batch_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: :all_blank
  validate :remove_stock, if: :need_to_remove_stock
  
  validates :batch_details, presence: true, on: :update

  def available_batches
    if !inventary.nil?
      (batches.map{|g| [g.serial, g.id]} + inventary.batches.availables.map { |g| [g.serial, g.id] }).uniq
    else
      []
    end
  end

  def batch_prompt
    if product
      if product.batches.availables.any?
        "Seleccione..."
      else
        "Sin stock"
      end
    else
      "Seleccione"
    end
  end

  def has_batches_with_errors?
    batches.map{|b| b.errors.any?}.include?(true)
  end

  def store
    parent.store
  end

  def remove_stock
    begin
      Stock::Manager.new(product: product, detail: self, batches: batches).remove_stock(quantity)
      childs.each{|child| child.need_to_remove_stock = true} 
    rescue InsuficientStockError => error
      errors.add(:quantity, "Stock insuficiente")
    end
  end

  def add_stock
    Stock::Manager.new(product: product, detail: self, batches: batches).add_stock(quantity, :rollback)
  end
end
