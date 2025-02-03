class SupplierAccountMovement < AccountMovement
	belongs_to :supplier, foreign_key: "entity_id"
	belongs_to :payment_bill, class_name: "ExternalBill", optional: true, foreign_key: "bill_id"
	belongs_to :payment_order, class_name: "Purchases::PaymentOrder", optional: true, foreign_key: "payment_order_id"

	def parent
		bill_id.blank? ? :payment_order : :bill
	end

	def self.update_dates
		SupplierAccountMovement.all.each do |am|
			movement_parent = eval("am.#{am.parent.to_s}")
			am.update_column(:date, movement_parent.date) unless movement_parent.nil?
		end
	end

	def income?
	    flow == "income"
	end

	def expense?
	    !income?
	end
end
