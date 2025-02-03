class SalePriceHistory < PriceHistory
	belongs_to :client, foreign_key: :entity_id
end