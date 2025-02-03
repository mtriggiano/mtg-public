class Product < Inventary
	default_scope ->{where(type: "Product", active: true)}
	accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

	belongs_to  :product_category, counter_cache: true
	belongs_to  :supplier, class_name: 'Supplier', foreign_key: 'supplier_id', inverse_of: :related_products
	has_many    :box_products, inverse_of: :product
	has_many    :price_histories
	has_many    :external_bill_details
	has_many    :sales_bill_details, class_name: 'Sales::BillDetail'
	has_many    :purchases_order_details, class_name: 'Purchases::OrderDetail'
	has_many   :budget_details, class_name: 'ExpedientBudgetDetail'
	has_many   :budgets, through: :budget_details, source: :expedient_budget
	has_many    :arrivals, through: :arrival_details
	has_many    :boxes, through: :box_products
	has_many 	:supplier_products, foreign_key: :product_id
	has_many 	:suppliers, through: :supplier_products
	has_many    :batches
	has_many 	:batch_stores, through: :batches
	has_many 	:articles, foreign_key: :product_id, inverse_of: :product
  	has_many    :available_batches, ->{where(state: true)}, through: :arrival_details, source: :batches
	validates_presence_of :name, message: 'Debe indicar un nombre al producto'
	validates_uniqueness_of :name, scope: [:active, :code, :gtin, :product_category_id], message: "El producto ya existe en la base de datos", case_sensitive: false
	validates_length_of :family, minimum: 3, maximum: 200, too_short: "Mínimo 3 caracteres", too_long: "Máximo 200 caracteres.", allow_blank: true
	after_save :update_category_counter, :touch_boxes
	
	validate :debe_tener_lote_por_defecto, on: :create
	before_validation :crear_lote_por_defecto

	accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: :all_blank
	accepts_nested_attributes_for :articles, allow_destroy: true, reject_if: :all_blank

	has_paper_trail only: [:buy_price]

	scope :by_store, -> (store_id) { 
	  includes(:batch_stores).where(batch_stores: {store_id: store_id})
	}

	def update_parent_type
		if saved_change_to_product_type?
			parent_product.update_column(:product_type, "box")
			self.update_column(:product_type, "child")
		end
	end

	def touch_boxes
		boxes.each(&:touch)
	end

	def fix_stock
		article = self.articles.find_by(store_id: 3)
		self.available_stock =  self.batches.select{|b| b.state }.sum(&:quantity)
		self.articles_attributes = { 0 => {id: article&.id, store_id: 3, available: self.available_stock.to_i} }
		self.save
		pp "saved"
	end

	# resetea en 0 todas las unidades de Stock disponible, Lotes y Depostisos
	def clean_stock
	  ActiveRecord::Base.transaction do
		available_stock = 0
	    articles.update(available: 0)
	    batch_stores.update(quantity: 0)
	    batches.update(quantity: 0, state: false)
	  end
	end

	def fix_batch_sn_stock
	  real_stock = articles.sum(&:available)
		batches_stock = 0
		sn_batch = default_batch
		if sn_batch.quantity >= 0 && batches.count == 1
			sn_batch.update_columns(quantity: real_stock, state: true)
		elsif batches.count > 1
			real_stock -= batches.where.not(id: sn_batch.id).includes(:batch_details).map(&:real_stock).reduce(:+)
			sn_batch.update_columns(quantity: real_stock < 0 ? 0 : real_stock, state: real_stock > 0 ? true : false)
		end
	end

	def default_batch
	  batches.default_batch
	end

	def totales_deben_coincidir
	  product = self
	  result = {}
	  
	  result[:product_id] = product.id
	  result[:available_stock] = product.available_stock
	  
	  
	  result[:real_articles] = product.articles.pluck(:available).sum
	  result[:batch_stores] = product.batch_stores.pluck(:quantity).sum
	  result[:batches] = product.batches.pluck(:quantity).sum
	  
	  
	  result
	end

	private 
	def debe_tener_lote_por_defecto
	  errors.add(:Base, "El producto debe tener al menos un lote por defecto.") if self.batches.select{|batch| batch.default }.blank?
	end

	def crear_lote_por_defecto
	  self.batches.build(code: "S/N", quantity: 0, default: true) if self.batches.default_batch.blank?
	end

	

end
