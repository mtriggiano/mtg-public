class Purchases::BillInventary < Purchases::BillDetail
	self.inheritance_column = :subtype
	include ProductDetails

	has_many   :order_details,
              ->(detail){where(product_id: detail.product_id)},
              through: :orders,
              source: :details



end
