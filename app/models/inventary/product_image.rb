class ProductImage < ApplicationRecord
    belongs_to :inventary, foreign_key: :product_id, inverse_of: :images
end
