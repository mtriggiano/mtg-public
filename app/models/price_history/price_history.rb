class PriceHistory < ApplicationRecord
  validates_presence_of :entity_id
  belongs_to :product
  belongs_to :entity
end