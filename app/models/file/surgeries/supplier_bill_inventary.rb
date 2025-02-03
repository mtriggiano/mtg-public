class Surgeries::SupplierBillInventary < Surgeries::SupplierBillDetail
	self.inheritance_column = :subtype
	include ProductDetails
	
	has_many   :sale_order_details,
              ->(detail){where(product_id: detail.product_id)},
              through: :sale_orders,
              source: :details

    def merge_with_sale_order
	    sale_order_details.each do |sale_order_detail|
			sale_order_detail.billed          = true
			sale_order_detail.bill_detail_id  = id
			sale_order_detail.bill_state      = supplier_bill.state
			sale_order_detail.billed_quantity = quantity
			sale_order_detail.save
	    end
	end

end