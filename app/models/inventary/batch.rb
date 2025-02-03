# frozen_string_literal: true

class Batch < ApplicationRecord
  include Virtus.model(mass_assignment: false, constructor: false)
  belongs_to :supplier_product, optional: true
  belongs_to :product, optional: true
  has_many :batch_stores
  has_many :stores, through: :batch_stores
  
  validates_uniqueness_of :serial, scope: [ :code, :product_id], message: "Esta intentando cargar un N° de serie ya cargado anteriormente. %{value}", 
    allow_blank: true, 
    case_sensitive: false, 
    if: :serial_changed_and_product_id_present?

  def serial_changed_and_product_id_present?
    serial_changed? && product_id.present?
  end
    
  validate :cantidad_igual_o_mayor_a_cero

  has_many :batch_details

  scope :availables, -> { where state: true }
  scope :delivered, -> { where state: false }
  scope :default_batch, -> { where(default: true).first }
  validate :solo_un_default_batch_por_producto

  scope :by_product_code, -> (code) { includes(:product).where("products.code ILIKE ?", "%#{code}%").references(:product) }
  scope :by_product_branch, -> (branch) { includes(:product).where("products.branch ILIKE ?", "%#{branch}%").references(:product) }
  scope :by_product_name, -> (name) { includes(:product).where("products.name ILIKE ?", "%#{name}%").references(:product) }
  
  def solo_un_default_batch_por_producto
    if default && product && product.batches.where(default: true).where.not(id: id).any?
      errors.add(:default, 'solo puede haber un lote predeterminado por producto')
    end
  end

  attribute :moved_quantity, Float

  def  cantidad_igual_o_mayor_a_cero
    if quantity.present? && quantity < 0
      errors.add(:quantity, "Stock insuficiente en el lote: #{code} serie: #{serial} para el producto #{product.name}")
    end
  end

  def available?
    state
  end

  def moved_quantity
    super || 1
  end

  def total_quantity
    quantity
  end

  def set_code
    self.code = self.code&.upcase
  end

  def movements
    batch_details
  end

  def full_text
    if !code.blank? && !serial.blank?
      "LOTE: #{code} - SERIE: #{serial} - Cant: #{quantity} - Vto: #{due_date.nil? ? 'S/vto' : due_date}"
    elsif !code.blank? && serial.blank?
      "LOTE: #{code} - Cant: #{quantity} - Vto: #{due_date.nil? ? 'S/vto' : due_date}"
    elsif !serial.blank? && code.blank?
      "SERIE: #{serial} - Cant: #{quantity} - Vto: #{due_date.nil? ? 'S/vto' : due_date}"
    end
  end

  def self.search_by_product_categories search
    unless search.blank?
      where(products: {product_category_id: search})
    else
      all
    end
  end

  def self.search_by_product_name_code search
    unless search.blank?
      where("products.name ILIKE (:search) OR products.code ILIKE (:search) OR products.branch ILIKE(:search) OR products.family ILIKE(:search)", search: "%#{search.upcase}%")
    else
      all
    end
  end

  def self.search_by_date(from: Date.today.beginning_of_year, to: Date.today.end_of_year)
    where(due_date:[from .. to])
  end

  def self.search_by_month(month: Date.today.month)
    return all if month == 0 || month.blank?
    where("EXTRACT(month FROM batches.due_date) IN (?)", month)
  end

  def self.sub_search from: Date.today - 1.months, to: Date.today, products:
    return all if products.nil? || products.size == 0
    where(product_id: products)
    .where(date: [from..to])
  end

  def real_stock
    stock_count = 0
    if batch_details.blank?
      stock_count = quantity
    else
      batch_details.each do |detail|
        case detail.detail_type
        when "ExpedientArrivalDetail"
          stock_count += detail.quantity
        when "ExpedientShipmentDetail"
          stock_count -= detail.quantity
        when "ExpedientConsumptionDetail"
          stock_count -= detail.quantity
        when "ExpedientDevolutionDetail"
          stock_count += detail.quantity
        end
      end
    end
    return stock_count
  end

  def increase_batch_stores(store, quantity)
    batch_store = batch_stores.where(store: store).first

    batch_store ||= batch_stores.build(
      store: store,
      quantity: 0
    )

    batch_store.quantity += quantity
    batch_store.save
  end

  def decrease_batch_stores(store, quantity)
    batch_store = batch_stores.where(store: store).first
    puts "Errores para ver en consola"
    puts "batch store id #{batch_store.try(:id)}"
    if batch_store.nil? || batch_store.quantity < quantity
      puts "deposito #{store.id}"
      puts "cantidad #{quantity}"
      raise StandardError.new("Stock insuficiente en el lote: #{code} serie: #{serial} para el producto #{product.name} en el deposito #{store.id}-#{store.name} #{quantity} #{batch_store.try(:id)}")
    end
    batch_store.quantity -= quantity
    batch_store.save!
  end

  # resetea en 0 todas las unidades de Stock disponible para el lote
	def clean_stock
    return true if self.quantity <= 0
    ActiveRecord::Base.transaction do
      stores = self.batch_stores.pluck(:store_id)
      article = self.product.articles.where(store_id: stores).first 
      if article
        new_quantity = article.available - self.quantity
        new_quantity = 0 if new_quantity < 0
        article.update_column(:available, new_quantity)
      end
      self.batch_stores.update(quantity: 0)
      new_quantity = self.product.available_stock - self.quantity
      new_quantity = 0 if new_quantity < 0
      self.product.update_column(:available_stock, new_quantity)
      self.quantity = 0
      self.state = false
      self.save
    end
	end

end
