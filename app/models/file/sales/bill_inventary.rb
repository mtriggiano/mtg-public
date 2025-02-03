class Sales::BillInventary < Sales::BillDetail
	self.inheritance_column = :subtype
	include ProductDetails
	
	has_many   :order_details,
              ->(detail){where(product_id: detail.product_id)},
              through: :orders,
              source: :details
    has_many   :shipment_details,
              ->(detail){where(product_id: detail.product_id)},
              through: :shipments,
              source: :details

	def parent
		bill
	end

end