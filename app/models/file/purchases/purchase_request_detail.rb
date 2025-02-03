class Purchases::PurchaseRequestDetail < ExpedientRequestDetail
	include ProductDetails
	include ProductInheritance
	belongs_to :purchase_request, foreign_key: :request_id, inverse_of: :details, optional: true
	before_validation :set_product_code

	self.ignored_columns = %w(product_supplier_code)

	TABLE_COLUMNS = {
		"Número" => {"important" => false,  "fixed" => false},
		"⚫" => {"important" => false,  "fixed" => false},
		'Producto' => { 'important' => true,   'fixed' => false },
		'Código' => { 'important' => true,   'fixed' => false },
		'Marca' => { 'important' => true,   'fixed' => false },
		'Cantidad solicitada' => { 'important' => false,  'fixed' => false },
		'Cantidad aprobada' => { 'important' => false, 'fixed' => false },
		'Especificación' => { 'important' => false,  'fixed' => false },
		'Acción' => { 'important' => true,   'fixed' => true }
	}.freeze

	def build_child_from_product product
		super do |d|
			d.product_supplier_code = product.supplier_code(d.parent.try(:entity_id))
			d.approved_quantity = 0
		end
	end

	def set_product_code
		self.product_code ||= self.inventary.code
	end

	def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
		super do |o|
			o.product_supplier_code  = sr_detail.product_supplier_code
			o.description            = sr_detail.description
			o.quantity 			 	 += sr_detail.quantity.to_i - sr_detail.purchase_requested_quantity.to_i
			o.approved_quantity  	 = sr_detail.quantity
			o.mark_for_destruction unless o.quantity > 0
		end
	end

	def build_inheritance detail
		self.product_id            =  detail[:product_id]
		self.product_name          =  detail[:product_name]
		self.quantity              =  detail[:quantity]
		self.approved_quantity     =  detail[:quantity]
		self.product_measurement   =  detail[:product_measurement]
		self.state                 =  "Pendiente"
		return self
	end

	def info
		state_point = {steps: []}
		if ordered
		  	state_point[:steps].push({
				title: "Orden de compra asociada", description: "El producto fue asociado a una orden de compra con estado #{order_state}. Se asociaron #{order_quantity} #{product_measurement}"
		  	})
		else
		  	state_point[:steps].push({
				title: "Sin documento asociado", description: "Esperando que se asocie el producto a un remito de entrada."
		  	})
		end
		return state_point
	end

	def create_price_history
		records = []
		details.each do |detail|
		  	records << detail.inventary.purchase_price_histories.build(price: detail.supplier_price, entity_id: entity_id)
		end
		PurchasePriceHistory.import(records)
	end

end
