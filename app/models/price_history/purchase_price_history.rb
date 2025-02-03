class PurchasePriceHistory < PriceHistory
  belongs_to :supplier, foreign_key: :entity_id
end