class Box < Inventary
	default_scope ->{where(type: "Box")}
	has_and_belongs_to_many :suppliers
	has_many   :stocks
	has_many   :box_products, inverse_of: :box
	has_many   :products, through: :box_products
	has_many   :images, class_name: "ProductImage", foreign_key: :product_id, inverse_of: :inventary

	default_scope ->{where(traceable: false)}

	accepts_nested_attributes_for :images, 			allow_destroy: true, reject_if: :all_blank
	accepts_nested_attributes_for :box_products, 	allow_destroy: true, reject_if: :all_blank

	validates_presence_of :box_products, message: "Debe asignar al menos un producto"

	after_touch :set_stock

	def traceable
		false
	end

	def own_type
		own ? "propio" : "no propio"
	end

	def childs_stock
		products.sum(:available_stock)
	end

	def set_stock
		self.update_column(:available_stock, childs_stock == 0 ? 0 : 1)
	end

end
