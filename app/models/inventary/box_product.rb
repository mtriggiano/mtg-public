class BoxProduct < ApplicationRecord
  	belongs_to :product, inverse_of: :box_products
  	belongs_to :box, inverse_of: :box_products

  	validates_presence_of :box, :product
  	validates_presence_of :quantity, message: "Debe indicar cantidad."
    validates_uniqueness_of :product_id, scope: [:box_id, :active]

  	validate :product_and_box_of_the_same_type

  	def product_and_box_of_the_same_type
  		unless product.own == box.own
  			box.errors.add(:base, "Uno o más productos no son del mismo tipo (#{box.own_type})")
  			errors.add(:base)
  		end
  	end
end
