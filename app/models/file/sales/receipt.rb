class Sales::Receipt < ExpedientReceipt
	belongs_to 	:file, class_name: "Sales::File", foreign_key: :file_id

	has_many :details, class_name: "Sales::ReceiptBill", foreign_key: :receipt_id, inverse_of: :receipt
	has_many :bills, through: :details
	has_many :responsables, through: :bills

	accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
end
