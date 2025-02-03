class Tenders::BillInventary < Tenders::BillDetail
	self.inheritance_column = :subtype
	include ProductDetails
	
	has_many   :order_details,
              ->(detail){where(product_id: detail.product_id)},
              through: :orders,
              source: :details

    def merge_with_order
	    order_details.each do |order_detail|
			order_detail.billed          = true
			order_detail.bill_detail_id  = id
			order_detail.bill_state      = bill.state
			order_detail.billed_quantity = quantity
			order_detail.save
	    end
	end

end