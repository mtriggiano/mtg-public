class Surgeries::ReceiptBill < ExpedientReceiptBill
	belongs_to :receipt, class_name: "Surgeries::Receipt", inverse_of: :details

	def set_childs_parent
		return true
  	end
end