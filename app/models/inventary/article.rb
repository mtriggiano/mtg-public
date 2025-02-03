class Article < ApplicationRecord
	self.table_name = :stocks
	belongs_to :product, inverse_of: :articles
	belongs_to :store
	validates :available, numericality: {greater_than_or_equal_to: 0}

	before_validation :raise_exception_if_invalid
	#validates_uniqueness_of :product_id, scope: [:store_id], if: :active
	#before_validation :check_available
	after_save :set_product_stock


	def raise_exception_if_invalid
		raise InsuficientStockError.new("Stock insuficiente") if available < 0


	end

	def set_product_stock
		product.update_column(:available_stock, product.articles.sum(:available))
	end
end
