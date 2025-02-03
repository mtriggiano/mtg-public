class Sales::ReceiptBill < ExpedientReceiptBill
	belongs_to :receipt, class_name: "Sales::Receipt", inverse_of: :details
	belongs_to :payment_type

	def set_childs_parent
		return true
	end
end
