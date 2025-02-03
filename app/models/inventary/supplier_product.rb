class SupplierProduct < ApplicationRecord
  belongs_to :product
  belongs_to :supplier, foreign_key: :entity_id
  has_many :batches

  def self.serach search
      product_id = search[:explicit_data]
      supplier_id = search[:extra_data]
      if supplier_id
        where(product_id: product_id, entity_id: supplier_id)
      else
        where(product_id: product_id)
      end
  end
end
